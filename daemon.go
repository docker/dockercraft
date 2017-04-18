package main

import (
	"bytes"
	"context"
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
	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/events"
	"github.com/docker/docker/api/types/filters"
	"github.com/docker/docker/client"
)

// TCPMessage defines what a message that can be
// sent or received to/from LUA scripts
type TCPMessage struct {
	Cmd  string   `json:"cmd,omitempty"`
	Args []string `json:"args,omitempty"`
	// Id is used to associate requests & responses
	ID   int         `json:"id,omitempty"`
	Data interface{} `json:"data,omitempty"`
}

// StatsOptionsEntry is used to collect stats from
// the Docker daemon
type StatsOptionsEntry struct {
	statsChan chan *types.StatsJSON
	doneChan  chan bool
}

// ContainerEvent is one kind of Data that can
// be transported by a TCPMessage in the Data field.
// It describes a Docker container event. (start, stop, destroy...)
type ContainerEvent struct {
	Action    string `json:"action,omitempty"`
	ID        string `json:"id,omitempty"`
	Name      string `json:"name,omitempty"`
	ImageRepo string `json:"imageRepo,omitempty"`
	ImageTag  string `json:"imageTag,omitempty"`
	CPU       string `json:"cpu,omitempty"`
	RAM       string `json:"ram,omitempty"`
	Running   bool   `json:"running,omitempty"`
}

// Daemon maintains state when the dockercraft daemon is running
type Daemon struct {
	// Client is an instance of the DockerClient
	Client *client.Client
	// Version is the version of the Docker Daemon
	Version string
	// BinaryName is the name of the Docker Binary
	BinaryName string
	// previouscpustats is a map containing the previous cpu stats we got from the
	// docker daemon through the docker remote api
	previousCPUStats map[string]*CPUStats

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
	d.Client, err = client.NewEnvClient()
	if err != nil {
		return err
	}

	// get the version of the remote docker
	info, err := d.Client.Info(context.Background())
	if err != nil {
		log.Fatal(err.Error())
	}
	d.Version = info.ServerVersion
	d.statsOptionsStore = make(map[string]StatsOptionsEntry)
	d.tcpMessages = make(chan []byte)

	return nil
}

// Serve exposes a TCP server on port 25566 to handle
// connections from the LUA scripts
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

// StartMonitoringEvents listens for events from the
// Docker daemon and uses callback to transmit them
// to LUA scripts.
func (d *Daemon) StartMonitoringEvents() {
	log.Info("Monitoring Docker Events")
	filters := filters.NewArgs()
	filters.Add("type", events.ContainerEventType)
	opts := types.EventsOptions{
		Filters: filters,
	}

	//context.TODO, cancel := context.WithCancel(d.context.TODO)
	//defer cancel()
	events, errs := d.Client.Events(context.Background(), opts)
	for {
		select {
		case event := <-events:
			log.Info("New Event Received")
			d.eventCallback(event)
		case err := <-errs:
			log.Fatal(err.Error())
		}
	}
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
		log.Debug("tcpMessage:", string(tcpMessage))
		_, err := conn.Write(tcpMessage)
		if err != nil {
			log.Fatal("conn write error:", err)
		}
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

	log.Debugf("handleMessage: %#v \n", tcpMsg)

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
func (d *Daemon) eventCallback(event events.Message) {

	containerEvent, err := d.apiEventToContainerEvent(event)
	if err != nil {
		log.Println("apiEventToContainerEvent error:", err)
		return
	}

	switch event.Status {

	case "create":
		log.Infof("Container Create Event received for %s", containerEvent.ID)
		containerEvent.Action = "createContainer"

		data, err := containerEventToTCPMsg(containerEvent)
		if err != nil {
			log.Println(err)
			return
		}

		d.tcpMessages <- append(data, '\n')
		log.Info("DONE")
	case "start":
		log.Infof("Container Start Event received for %s", containerEvent.ID)
		containerEvent.Action = "startContainer"

		data, err := containerEventToTCPMsg(containerEvent)
		if err != nil {
			log.Println(err)
			return
		}

		d.tcpMessages <- append(data, '\n')

		d.startStatsMonitoring(containerEvent.ID)
		log.Info("DONE")

	case "die":
		log.Infof("Container Die Event received for %s", containerEvent.ID)
		containerEvent.Action = "stopContainer"

		data, err := containerEventToTCPMsg(containerEvent)
		if err != nil {
			log.Println(err)
			return
		}

		d.tcpMessages <- append(data, '\n')

		d.Lock()
		log.Info("Removing Container")
		statsOptionsEntry, found := d.statsOptionsStore[containerEvent.ID]
		if found {
			log.Info("Sending Done on channel")
			close(statsOptionsEntry.doneChan)
			log.Info("Deleting the entry from the list")
			delete(d.statsOptionsStore, containerEvent.ID)
		}
		d.Unlock()

		// enforce 0% display (Cpu & Ram)
		d.statCallback(containerEvent.ID, nil)
		log.Info("DONE")

	case "destroy":
		log.Infof("Container Destroy Event received for %s", containerEvent.ID)
		containerEvent.Action = "destroyContainer"

		data, err := containerEventToTCPMsg(containerEvent)
		if err != nil {
			log.Println(err)
			return
		}
		d.tcpMessages <- append(data, '\n')
		log.Info("DONE")

	default:
		// Ignoring
		log.Debug("Ignoring event: %s", event.Status)
	}
}

// statCallback receives the stats (cpu & ram) from containers and send them to
// the cuberite server
func (d *Daemon) statCallback(id string, stats *types.StatsJSON, args ...interface{}) {
	containerEvent := ContainerEvent{}
	containerEvent.ID = id
	containerEvent.Action = "stats"

	if stats != nil {
		memPercent := float64(stats.MemoryStats.Usage) / float64(stats.MemoryStats.Limit) * 100.0
		var cpuPercent float64
		if preCPUStats, exists := d.previousCPUStats[id]; exists {
			cpuPercent = calculateCPUPercent(preCPUStats, &stats.CPUStats)
		}

		d.previousCPUStats[id] = &CPUStats{TotalUsage: stats.CPUStats.CPUUsage.TotalUsage, SystemUsage: stats.CPUStats.SystemUsage}

		containerEvent.CPU = strconv.FormatFloat(cpuPercent, 'f', 2, 64) + "%"
		containerEvent.RAM = strconv.FormatFloat(memPercent, 'f', 2, 64) + "%"
	} else {
		// if stats == nil set Cpu and Ram to 0%
		// it's a way to enforce these values
		// when stopping a container
		containerEvent.CPU = "0.00%"
		containerEvent.RAM = "0.00%"
	}

	tcpMsg := TCPMessage{}
	tcpMsg.Cmd = "event"
	tcpMsg.Args = []string{"containers"}
	tcpMsg.ID = 0
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
		log.Debugln("execDockerCmd:", d.BinaryName, args)
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
		containers, err := d.Client.ContainerList(context.Background(), types.ContainerListOptions{All: true})
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
			containerEvent.ID = id
			containerEvent.Action = "containerInfos"
			containerEvent.ImageRepo = imageRepo
			containerEvent.ImageTag = imageTag
			containerEvent.Name = name
			containerEvent.Running = container.State == "running"

			data, err := containerEventToTCPMsg(containerEvent)
			if err != nil {
				log.Println(err)
				return
			}

			d.tcpMessages <- append(data, '\n')

			if containerEvent.Running {
				// Monitor stats
				d.startStatsMonitoring(containerEvent.ID)
			} else {
				// enforce 0% display (Cpu & Ram)
				d.statCallback(containerEvent.ID, nil)
			}
		}
	}()
}

func (d *Daemon) startStatsMonitoring(containerID string) {
	d.Lock()
	statsOptionsEntry, found := d.statsOptionsStore[containerID]
	if !found {
		statsOptionsEntry = StatsOptionsEntry{
			make(chan *types.StatsJSON),
			make(chan bool, 1),
		}
		d.statsOptionsStore[containerID] = statsOptionsEntry
	}
	d.Unlock()

	go func() {
		log.Infof("Start monitoring stats: %s", containerID)
		resp, err := d.Client.ContainerStats(context.Background(), containerID, true)
		if err != nil {
			log.Printf("dClient.Stats err: %#v", err)
		}
		defer resp.Body.Close()
		dec := json.NewDecoder(resp.Body)
		for {
			select {
			case <-statsOptionsEntry.doneChan:
				log.Infof("Stopping collecting stats for %s", containerID)
				return
			default:
				v := types.StatsJSON{}
				if err := dec.Decode(&v); err != nil {
					dec = json.NewDecoder(io.MultiReader(dec.Buffered(), resp.Body))
					if err != io.EOF {
						break
					}
					time.Sleep(100 * time.Millisecond)
					continue
				}
				statsOptionsEntry.statsChan <- &v
			}
		}
	}()

	go func() {
		for {
			select {
			case stats := <-statsOptionsEntry.statsChan:
				if stats != nil {
					d.statCallback(containerID, stats)
				}
			case <-statsOptionsEntry.doneChan:
				log.Println("Go routine END")
				return
			}
		}
	}()
}

// Utility functions

func calculateCPUPercent(previousCPUStats *CPUStats, newCPUStats *types.CPUStats) float64 {
	var (
		cpuPercent = 0.0
		// calculate the change for the cpu usage of the container in between readings
		cpuDelta = float64(newCPUStats.CPUUsage.TotalUsage - previousCPUStats.TotalUsage)
		// calculate the change for the entire system between readings
		systemDelta = float64(newCPUStats.SystemUsage - previousCPUStats.SystemUsage)
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

func containerEventToTCPMsg(containerEvent ContainerEvent) ([]byte, error) {
	tcpMsg := TCPMessage{}
	tcpMsg.Cmd = "event"
	tcpMsg.Args = []string{"containers"}
	tcpMsg.ID = 0
	tcpMsg.Data = &containerEvent
	data, err := json.Marshal(&tcpMsg)
	if err != nil {
		return nil, errors.New("containerEventToTCPMsg error: " + err.Error())
	}
	return data, nil
}

func (d *Daemon) apiEventToContainerEvent(event events.Message) (ContainerEvent, error) {

	containerEvent := ContainerEvent{}
	containerEvent.ID = event.Actor.ID

	// don't try to inspect container in that case, it's already gone!
	if event.Action == "destroy" {
		return containerEvent, nil
	}

	log.Debugf("apiEventToContainerEvent: %#v\n", event)
	container, err := d.Client.ContainerInspect(context.Background(), containerEvent.ID)
	if err != nil {
		return containerEvent, err
	}
	containerEvent.ImageRepo, containerEvent.ImageTag = splitRepoAndTag(event.From)
	if containerEvent.ImageTag == "" {
		containerEvent.ImageTag = "latest"
	}
	containerEvent.Name = container.Name
	return containerEvent, nil
}
