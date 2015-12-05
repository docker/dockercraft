package main

import (
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"strconv"
	"strings"

	log "github.com/Sirupsen/logrus"
	"github.com/samalba/dockerclient"
)

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
	Machines map[string]*Machine
}

// NewDaemon returns a new instance of Daemon
func NewDaemon() *Daemon {
	return &Daemon{
		Machines: make(map[string]*Machine),
	}
}

// CPUStats contains the Total and System CPU stats
type CPUStats struct {
	TotalUsage  uint64
	SystemUsage uint64
}

// ProxyCmd submits a command to a running Daemon
func ProxyCmd(args []string) error {
	if len(args) != 1 {
		return fmt.Errorf("One argument expected. Received %d", len(args))
	}
	reqPath := "http://127.0.0.1:8000/" + os.Args[1]
	resp, err := http.Get(reqPath)
	if err != nil {
		return fmt.Errorf("Error on request: %s, ERROR: %s", reqPath, err.Error())
	}
	log.Debugf("Request sent: %s, StatusCode: %d", reqPath, resp.StatusCode)
	return nil
}

// Init initializes a Daemon
func (d *Daemon) Init() error {

	if err := d.GetMachines(); err != nil {
		return err
	}

	if len(d.Machines) == 0 {
		return fmt.Errorf("No Machines Found!")
	}

	for m, machine := range d.Machines {
		var err error
		machine.Client, err = dockerclient.NewDockerClient(machine.URL, machine.TLSConfig)
		if err != nil {
			log.Warn("Error connecting to machine %s: %s", m, err)
			delete(d.Machines, m)
			continue
		}

		// get the version of the docker remote API
		version, err := machine.Client.Version()
		if err != nil {
			log.Warn("Error connecting to machine %s: %s", m, err)
			delete(d.Machines, m)
			continue

		}
		machine.Version = version.Version
	}
	return nil
}

// eventCallback receives and handles the docker events
func (m *Machine) eventCallback(event *dockerclient.Event, ec chan error, args ...interface{}) {
	log.Debugf("--\n%+v", *event)
	id := event.ID

	switch event.Status {
	case "create":
		log.Debug("create event")

		repo, tag := splitRepoAndTag(event.From)
		containerName := "<name>"
		containerInfo, err := m.Client.InspectContainer(id)
		if err != nil {
			log.Errorf("InspectContainer error: %s", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"world":     {m.Name},
			"action":    {"createContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		CuberiteServerRequest(data)

	case "start":
		log.Debugln("start event")

		repo, tag := splitRepoAndTag(event.From)
		containerName := "<name>"
		containerInfo, err := m.Client.InspectContainer(id)
		if err != nil {
			log.Errorf("InspectContainer error: %s", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"world":     {m.Name},
			"action":    {"startContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		// Monitor stats
		m.Client.StartMonitorStats(id, m.statCallback, nil)
		CuberiteServerRequest(data)

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
		log.Debugln("die event")

		// same as stop event
		repo, tag := splitRepoAndTag(event.From)
		containerName := "<name>"
		containerInfo, err := m.Client.InspectContainer(id)
		if err != nil {
			log.Errorf("InspectContainer error: %s", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"world":     {m.Name},
			"action":    {"stopContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		CuberiteServerRequest(data)

	case "destroy":
		log.Debug("destroy event")

		data := url.Values{
			"world":  {m.Name},
			"action": {"destroyContainer"},
			"id":     {id},
		}

		CuberiteServerRequest(data)
	}
}

// statCallback receives the stats (cpu & ram) from containers and send them to
// the cuberite server
func (m *Machine) statCallback(id string, stat *dockerclient.Stats, ec chan error, args ...interface{}) {

	// log.Debugln("STATS", id, stat)
	// log.Debugln("---")
	// log.Debugln("cpu :", float64(stat.CpuStats.CpuUsage.TotalUsage)/float64(stat.CpuStats.SystemUsage))
	// log.Debugln("ram :", stat.MemoryStats.Usage)

	memPercent := float64(stat.MemoryStats.Usage) / float64(stat.MemoryStats.Limit) * 100.0
	var cpuPercent float64
	m.previousCPUStatsLock.RLock()
	if preCPUStats, exists := m.previousCPUStats[id]; exists {
		cpuPercent = calculateCPUPercent(preCPUStats, &stat.CpuStats)
	}
	m.previousCPUStatsLock.RUnlock()

	m.previousCPUStatsLock.Lock()
	m.previousCPUStats[id] = &CPUStats{TotalUsage: stat.CpuStats.CpuUsage.TotalUsage, SystemUsage: stat.CpuStats.SystemUsage}
	m.previousCPUStatsLock.Unlock()

	data := url.Values{
		"world":  {m.Name},
		"action": {"stats"},
		"id":     {id},
		"cpu":    {strconv.FormatFloat(cpuPercent, 'f', 2, 64) + "%"},
		"ram":    {strconv.FormatFloat(memPercent, 'f', 2, 64) + "%"}}

	CuberiteServerRequest(data)
}

// execCmd handles http requests received for the path "/exec"
func (d *Daemon) execCmd(w http.ResponseWriter, r *http.Request) {

	io.WriteString(w, "OK")

	go func() {
		machine := r.URL.Query().Get("world")
		cmd := r.URL.Query().Get("cmd")
		cmd, _ = url.QueryUnescape(cmd)
		arr := strings.Split(cmd, " ")
		if len(arr) > 0 {
			if arr[0] != "docker" {
				log.Errorf("Aborting. %s is not a supported command", arr[0])
			}
			// switch "docker" for the binary name
			arr[0] = d.Machines[machine].BinaryName
			hostArgs := d.Machines[machine].GetDockerConfig()
			arr = append(arr[:1], append(hostArgs, arr[1:]...)...)
			log.Debugf("Command: %+v\n", arr)
			cmd := exec.Command(arr[0], arr[1:]...)
			// Stdout buffer
			// cmdOutput := &bytes.Buffer{}
			// Attach buffer to command
			// cmd.Stdout = cmdOutput
			// Execute command
			// printCommand(cmd)
			err := cmd.Run() // will wait for command to return
			if err != nil {
				log.Error(err.Error())
			}
		}
	}()
}

// listContainers handles and reply to http requests having the path "/containers"
func (d *Daemon) listContainers(w http.ResponseWriter, r *http.Request) {

	// answer right away to avoid dead locks in LUA
	io.WriteString(w, "OK")

	go func(r *http.Request) {
		log.Debug("Entering goroutine")
		machine := r.URL.Query().Get("world")
		log.Debugf("Machine is %s", machine)
		log.Debugf("Getting containers")
		containers, err := d.Machines[machine].Client.ListContainers(true, false, "")

		if err != nil {
			log.Error(err.Error())
			return
		}

		log.Debugf("Getting images")
		images, err := d.Machines[machine].Client.ListImages(true)

		if err != nil {
			log.Error(err.Error())
			return
		}

		log.Debugf("%d containers found in %s", len(containers), machine)
		for i := 0; i < len(containers); i++ {
			id := containers[i].Id
			log.Debugf("Looking at container %s", id)
			info, _ := d.Machines[machine].Client.InspectContainer(id)
			name := info.Name[1:]
			imageRepo := ""
			imageTag := ""

			for _, image := range images {
				if image.Id == info.Image {
					if len(image.RepoTags) > 0 {
						imageRepo, imageTag = splitRepoAndTag(image.RepoTags[0])
					}
					break
				}
			}

			data := url.Values{
				"world":     {machine},
				"action":    {"containerInfos"},
				"id":        {id},
				"name":      {name},
				"imageRepo": {imageRepo},
				"imageTag":  {imageTag},
				"running":   {strconv.FormatBool(info.State.Running)},
			}

			log.Debugf("Sending  %+v", data)
			CuberiteServerRequest(data)

			if info.State.Running {
				// Monitor stats
				d.Machines[machine].Client.StartMonitorStats(id, d.Machines[machine].statCallback, nil)
			}
		}
	}(r)
}

// Utility functions

func calculateCPUPercent(previousCPUStats *CPUStats, newCPUStats *dockerclient.CpuStats) float64 {
	var (
		cpuPercent = 0.0
		// calculate the change for the cpu usage of the container in between readings
		cpuDelta = float64(newCPUStats.CpuUsage.TotalUsage - previousCPUStats.TotalUsage)
		// calculate the change for the entire system between readings
		systemDelta = float64(newCPUStats.SystemUsage - previousCPUStats.SystemUsage)
	)

	if systemDelta > 0.0 && cpuDelta > 0.0 {
		cpuPercent = (cpuDelta / systemDelta) * float64(len(newCPUStats.CpuUsage.PercpuUsage)) * 100.0
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

// CuberiteServerRequest send a POST request that will be handled
// by our Cuberite Docker plugin.
func CuberiteServerRequest(data url.Values) {
	client := &http.Client{}
	req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Docker/Docker", strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	client.Do(req)
}
