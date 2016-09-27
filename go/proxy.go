package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"io"
	"net"
	"os/exec"
	"strconv"
	"strings"
	"sync"
	"time"

	log "github.com/Sirupsen/logrus"
	"github.com/fsouza/go-dockerclient"
)

type TCPMessage struct {
	Cmd  string   `json:"cmd,omitempty"`
	Args []string `json:"args,omitempty"`
	// Id is used to associate requests & responses
	Id   int         `json:"id,omitempty"`
	Data interface{} `json:"data,omitempty"`
}

type StatsOptionsEntry struct {
	statsOptions docker.StatsOptions
	// statsOptions can only store the one-way channel
	// that's why that extra field is required
	statsChan chan *docker.Stats
	// same comment as for statsChan
	doneChan chan bool
}

// ContainerEvent is one kind of Data that can
// be transported by a TCPMessage in the Data field.
// It describes a Docker container event. (start, stop, destroy...)
type ContainerEvent struct {
	Action    string `json:"action,omitempty"`
	Id        string `json:"id,omitempty"`
	Name      string `json:"name,omitempty"`
	ImageRepo string `json:"imageRepo,omitempty"`
	ImageTag  string `json:"imageTag,omitempty"`
	Cpu       string `json:"cpu,omitempty"`
	Ram       string `json:"ram,omitempty"`
	Running   bool   `json:"running,omitempty"`
}

// goproxy main purpose is to be a daemon connecting the docker daemon
// (remote API) and the custom Minecraft server (cubrite using lua scripts).
// But the cuberite lua scripts also execute goproxy as a short lived process
// to send requests to the goproxy daemon. If the program is executed without
// additional arguments it is the daemon "mode".
//
// As a daemon, goproxy listens for events from the docker daemon and send
// them to the cuberite server. It also listen for requests from the
// cuberite server, convert them into docker daemon remote API calls and send
// them to the docker daemon.

// Daemon maintains state when the dockercraft daemon is running
type Daemon struct {
	// Client is an instance of the DockerClient
	Client *docker.Client
	// Version is the version of the Docker Daemon
	Version string
	// BinaryName is the name of the Docker Binary
	BinaryName string
	// previouscpustats is a map containing the previous cpu stats we got from the
	// docker daemon through the docker remote api
	previousCPUStats map[string]*CPUStats

	// containerEvents is a global variable channel
	// that receives all container events
	containerEvents chan *docker.APIEvents

	// tcpMessages can be used to send bytes to the Lua
	// plugin from any go routine.
	tcpMessages chan []byte

	// statsOptionsStore references docker.StatsOptions
	// of monitored containers.
	statsOptionsStore map[string]StatsOptionsEntry

	sync.Mutex
}

// NewDaemon returns a new instance of Daemon
func NewDaemon() *Daemon {
	return &Daemon{
		previousCPUStats: make(map[string]*CPUStats),
	}
}

// CPUStats contains the Total and System CPU stats
type CPUStats struct {
	TotalUsage  uint64
	SystemUsage uint64
}

// Init initializes a Daemon
func (d *Daemon) Init() error {
	var err error
	d.Client, err = docker.NewClient("unix:///var/run/docker.sock")
	if err != nil {
		return err
	}

	// get the version of the docker remote API
	env, err := d.Client.Version()
	if err != nil {
		return err
	}
	d.Version = env.Get("Version")

	d.statsOptionsStore = make(map[string]StatsOptionsEntry)
	d.tcpMessages = make(chan []byte)
	d.containerEvents = make(chan *docker.APIEvents)

	return nil
}

func (d *Daemon) Serve() {

	tcpAddr, err := net.ResolveTCPAddr("tcp", ":25566")

	ln, err := net.ListenTCP("tcp", tcpAddr)
	if err != nil {
		log.Fatalln("listen tcp error:", err)
	}
	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Fatalln("tcp conn accept error:", err)
		}
		// no need to handle connection in a go routine
		// goproxy is used as support for one single Lua plugin.
		d.handleConn(conn)
	}
}

func (d *Daemon) StartMonitoringEvents() {
	go func() {
		err := d.Client.AddEventListener(d.containerEvents)
		if err != nil {
			log.Fatal(err)
		}
		for {
			event := <-d.containerEvents
			d.eventCallback(event)
		}
	}()
}

// handleConn handles a TCP connection
// with a Dockercraft Lua plugin.
func (d *Daemon) handleConn(conn net.Conn) {

	go func() {
		separator := []byte(string('\n'))

		buf := make([]byte, 256)
		cursor := 0
		for {
			// resize buf if needed
			if len(buf)-cursor < 256 {
				buf = append(buf, make([]byte, 256-(len(buf)-cursor))...)
			}
			n, err := conn.Read(buf[cursor:])
			if err != nil && err != io.EOF {
				log.Fatalln("conn read error: ", err)
			}
			cursor += n

			// TODO(aduermael): check cNetwork plugin implementation
			// conn.Read doesn't seem to be blocking if there's nothing
			// to read. Maybe the broken pipe is due to an implementation
			// problem on cNetwork plugin side
			if cursor == 0 {
				<-time.After(500 * time.Millisecond)
				continue
			}
			// log.Println("TCP data read:", string(buf[:cursor]), "cursor:", cursor)

			// see if there's a complete json message in buf.
			// messages are separated with \n characters
			messages := bytes.Split(buf[:cursor], separator)
			// if one complete message and seperator is found
			// then we should have len(messages) > 1, the
			// last entry being an incomplete message or empty array.
			if len(messages) > 1 {
				shiftLen := 0
				for i := 0; i < len(messages)-1; i++ {
					// log.Println(string(messages[i]))

					msgCopy := make([]byte, len(messages[i]))
					copy(msgCopy, messages[i])

					go d.handleMessage(msgCopy)
					shiftLen += len(messages[i]) + 1
				}
				copy(buf, buf[shiftLen:])
				cursor -= shiftLen
			}
		}
	}()

	for {
		tcpMessage := <-d.tcpMessages
		log.Println("tcpMessage:", string(tcpMessage))
		_, err := conn.Write(tcpMessage)
		if err != nil {
			log.Fatal("conn write error:", err)
		}
		log.Println("written!")
	}
}

// handleMessage handles a message read
// from TCP connection
func (d *Daemon) handleMessage(message []byte) {

	var tcpMsg TCPMessage

	err := json.Unmarshal(message, &tcpMsg)
	if err != nil {
		log.Println("json unmarshal error:", err)
		return
	}

	switch tcpMsg.Cmd {
	case "docker":
		d.execDockerCmd(tcpMsg.Args)
	case "info":
		if len(tcpMsg.Args) > 0 {
			switch tcpMsg.Args[0] {
			case "containers":
				d.listContainers()
			}
		}
	}
}

// eventCallback receives and handles the docker events
func (d *Daemon) eventCallback(event *docker.APIEvents) {

	containerEvent, err := d.apiEventToContainerEvent(event)
	if err != nil {
		log.Println("apiEventToContainerEvent error:", err)
		return
	}

	switch event.Status {

	case "create":

		containerEvent.Action = "createContainer"

		data, err := containerEventToTcpMsg(containerEvent)
		if err != nil {
			log.Println(err)
			return
		}

		d.tcpMessages <- append(data, '\n')

	case "start":

		containerEvent.Action = "startContainer"

		data, err := containerEventToTcpMsg(containerEvent)
		if err != nil {
			log.Println(err)
			return
		}

		d.tcpMessages <- append(data, '\n')

		d.startStatsMonitoring(containerEvent.Id)

	case "stop":
		// die event is enough
		// http://docs.docker.com/reference/api/docker_remote_api/#docker-events

	case "restart":
		// start event is enough
		// http://docs.docker.com/reference/api/docker_remote_api/#docker-events

	case "kill":
		// die event is enough
		// http://docs.docker.com/reference/api/docker_remote_api/#docker-events

	case "die":

		containerEvent.Action = "stopContainer"

		data, err := containerEventToTcpMsg(containerEvent)
		if err != nil {
			log.Println(err)
			return
		}

		d.tcpMessages <- append(data, '\n')

		d.Lock()
		statsOptionsEntry, found := d.statsOptionsStore[containerEvent.Id]
		if found {
			close(statsOptionsEntry.doneChan)
			delete(d.statsOptionsStore, containerEvent.Id)
		}
		d.Unlock()

		// enforce 0% display (Cpu & Ram)
		d.statCallback(containerEvent.Id, nil)

	case "destroy":

		containerEvent.Action = "destroyContainer"

		data, err := containerEventToTcpMsg(containerEvent)
		if err != nil {
			log.Println(err)
			return
		}
		d.tcpMessages <- append(data, '\n')
	}
}

// statCallback receives the stats (cpu & ram) from containers and send them to
// the cuberite server
func (d *Daemon) statCallback(id string, stats *docker.Stats, args ...interface{}) {
	containerEvent := ContainerEvent{}
	containerEvent.Id = id
	containerEvent.Action = "stats"

	if stats != nil {
		memPercent := float64(stats.MemoryStats.Usage) / float64(stats.MemoryStats.Limit) * 100.0
		var cpuPercent float64 = 0.0
		if preCPUStats, exists := d.previousCPUStats[id]; exists {
			cpuPercent = calculateCPUPercent(preCPUStats, &stats.CPUStats)
		}

		d.previousCPUStats[id] = &CPUStats{TotalUsage: stats.CPUStats.CPUUsage.TotalUsage, SystemUsage: stats.CPUStats.SystemCPUUsage}

		containerEvent.Cpu = strconv.FormatFloat(cpuPercent, 'f', 2, 64) + "%"
		containerEvent.Ram = strconv.FormatFloat(memPercent, 'f', 2, 64) + "%"
	} else {
		// if stats == nil set Cpu and Ram to 0%
		// it's a way to enforce these values
		// when stopping a container
		containerEvent.Cpu = "0.00%"
		containerEvent.Ram = "0.00%"
	}

	tcpMsg := TCPMessage{}
	tcpMsg.Cmd = "event"
	tcpMsg.Args = []string{"containers"}
	tcpMsg.Id = 0
	tcpMsg.Data = &containerEvent

	data, err := json.Marshal(&tcpMsg)
	if err != nil {
		log.Println("statCallback error:", err)
		return
	}

	separator := []byte(string('\n'))

	d.tcpMessages <- append(data, separator...)
}

// execDockerCmd handles Docker commands
func (d *Daemon) execDockerCmd(args []string) {
	if len(args) > 0 {
		cmd := exec.Command(d.BinaryName, args...)
		err := cmd.Run() // will wait for command to return
		if err != nil {
			log.Println("Error:", err.Error())
		}
	}
}

// listContainers handles and reply to http requests having the path "/containers"
func (d *Daemon) listContainers() {
	go func() {
		containers, err := d.Client.ListContainers(docker.ListContainersOptions{All: true})
		if err != nil {
			log.Println(err.Error())
			return
		}

		for _, container := range containers {

			id := container.ID

			// get container name:
			// use first name in array
			// and remove leading '/'
			// if necessary
			name := ""
			if len(container.Names) > 0 {
				name = container.Names[0]
				if len(name) > 0 && name[0] == '/' {
					name = name[1:]
				}
			}

			imageRepo, imageTag := splitRepoAndTag(container.Image)
			if imageTag == "" {
				imageTag = "latest"
			}

			containerEvent := ContainerEvent{}
			containerEvent.Id = id
			containerEvent.Action = "containerInfos"
			containerEvent.ImageRepo = imageRepo
			containerEvent.ImageTag = imageTag
			containerEvent.Name = name
			// container.Status can be "paused", "Up <time>" or "Exit <code>"
			parts := strings.SplitN(container.Status, " ", 2)
			containerEvent.Running = len(parts) > 0 && parts[0] == "Up"

			data, err := containerEventToTcpMsg(containerEvent)
			if err != nil {
				log.Println(err)
				return
			}

			d.tcpMessages <- append(data, '\n')

			if containerEvent.Running {
				// Monitor stats
				d.startStatsMonitoring(containerEvent.Id)
			} else {
				// enforce 0% display (Cpu & Ram)
				d.statCallback(containerEvent.Id, nil)
			}
		}
	}()
}

func (d *Daemon) startStatsMonitoring(containerID string) {
	// Monitor stats
	go func() {
		var statsChan chan *docker.Stats
		var doneChan chan bool

		d.Lock()
		statsOptionsEntry, found := d.statsOptionsStore[containerID]
		if !found {
			statsChan = make(chan *docker.Stats)
			doneChan = make(chan bool)
			statsOptions := docker.StatsOptions{
				ID:      containerID,
				Stats:   statsChan,
				Stream:  true,
				Done:    doneChan,
				Timeout: time.Second * 60,
			}
			statsOptionsEntry = StatsOptionsEntry{statsOptions, statsChan, doneChan}
			d.statsOptionsStore[containerID] = statsOptionsEntry
		} else {
			statsChan = statsOptionsEntry.statsChan
			doneChan = statsOptionsEntry.doneChan
		}
		d.Unlock()

		go func() {
			log.Println("Start go routine to collect events from", containerID)
			for {
				select {
				case stats := <-statsChan:
					//!\\ stats == nil when channel is closed
					if stats != nil {
						d.statCallback(containerID, stats)
					}
				case <-doneChan:
					log.Println("Go routine END")
					return
				}
			}
		}()

		if !found {
			log.Println("Start monitoring events:", containerID)
			err := d.Client.Stats(statsOptionsEntry.statsOptions)
			if err != nil {
				log.Printf("dClient.Stats err: %#v", err)
			}
			log.Println("Stop monitoring events:", containerID)
		}
	}()
}

// Utility functions

func calculateCPUPercent(previousCPUStats *CPUStats, newCPUStats *docker.CPUStats) float64 {
	var (
		cpuPercent = 0.0
		// calculate the change for the cpu usage of the container in between readings
		cpuDelta = float64(newCPUStats.CPUUsage.TotalUsage - previousCPUStats.TotalUsage)
		// calculate the change for the entire system between readings
		systemDelta = float64(newCPUStats.SystemCPUUsage - previousCPUStats.SystemUsage)
	)

	if systemDelta > 0.0 && cpuDelta > 0.0 {
		cpuPercent = (cpuDelta / systemDelta) * float64(len(newCPUStats.CPUUsage.PercpuUsage)) * 100.0
	}
	return cpuPercent
}

func splitRepoAndTag(repoTag string) (string, string) {

	repo := ""
	tag := ""

	repoAndTag := strings.Split(repoTag, ":")

	if len(repoAndTag) > 0 {
		repo = repoAndTag[0]
	}

	if len(repoAndTag) > 1 {
		tag = repoAndTag[1]
	}

	return repo, tag
}

func containerEventToTcpMsg(containerEvent ContainerEvent) ([]byte, error) {
	tcpMsg := TCPMessage{}
	tcpMsg.Cmd = "event"
	tcpMsg.Args = []string{"containers"}
	tcpMsg.Id = 0
	tcpMsg.Data = &containerEvent
	data, err := json.Marshal(&tcpMsg)
	if err != nil {
		return nil, errors.New("containerEventToTcpMsg error: " + err.Error())
	}
	return data, nil
}

func (d *Daemon) apiEventToContainerEvent(event *docker.APIEvents) (ContainerEvent, error) {
	container, err := d.Client.InspectContainer(event.ID)
	if err != nil {
		return ContainerEvent{}, err
	}
	containerEvent := ContainerEvent{}
	containerEvent.Id = container.ID
	containerEvent.ImageRepo, containerEvent.ImageTag = splitRepoAndTag(event.From)
	if containerEvent.ImageTag == "" {
		containerEvent.ImageTag = "latest"
	}
	containerEvent.Name = container.Name
	return containerEvent, nil
}
