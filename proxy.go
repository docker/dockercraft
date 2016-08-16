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
	// Client is an instance of the DockerClient
	Client *dockerclient.DockerClient
	// Version is the version of the Docker Daemon
	Version string
	// BinaryName is the name of the Docker Binary
	BinaryName string
	// previouscpustats is a map containing the previous cpu stats we got from the
	// docker daemon through the docker remote api
	previousCPUStats map[string]*CPUStats
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

// ProxyCmd submits a command to a running Daemon
func ProxyCmd(args []string) error {
	if len(args) != 1 {
		return fmt.Errorf("Only 1 argument expected. Received %d", len(args))
	}
	reqPath := "http://127.0.0.1:8000/" + os.Args[1]
	resp, err := http.Get(reqPath)
	if err != nil {
		return fmt.Errorf("Error on request: %s, ERROR: %s", reqPath, err.Error())
	}
	log.Infof("Request sent: %s, StatusCode: %d", reqPath, resp.StatusCode)
	return nil
}

// Init initializes a Daemon
func (d *Daemon) Init() error {
	var err error
	d.Client, err = dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)
	if err != nil {
		return err
	}

	// get the version of the docker remote API
	version, err := d.Client.Version()
	if err != nil {
		return err
	}
	d.Version = version.Version
	return nil
}

// eventCallback receives and handles the docker events
func (d *Daemon) eventCallback(event *dockerclient.Event, ec chan error, args ...interface{}) {
	log.Debugf("--\n%+v", *event)

	id := event.ID

	switch event.Status {
	case "create":
		log.Debug("create event")

		repo, tag := splitRepoAndTag(event.From)
		containerName := "<name>"
		containerInfo, err := d.Client.InspectContainer(id)
		if err != nil {
			log.Errorf("InspectContainer error: %s", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
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
		containerInfo, err := d.Client.InspectContainer(id)
		if err != nil {
			log.Errorf("InspectContainer error: %s", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"action":    {"startContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		// Monitor stats
		d.Client.StartMonitorStats(id, d.statCallback, nil)
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
		containerInfo, err := d.Client.InspectContainer(id)
		if err != nil {
			log.Errorf("InspectContainer error: %s", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"action":    {"stopContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		CuberiteServerRequest(data)

	case "destroy":
		log.Debug("destroy event")

		data := url.Values{
			"action": {"destroyContainer"},
			"id":     {id},
		}

		CuberiteServerRequest(data)
	}
}

// statCallback receives the stats (cpu & ram) from containers and send them to
// the cuberite server
func (d *Daemon) statCallback(id string, stat *dockerclient.Stats, ec chan error, args ...interface{}) {

	// log.Debugln("STATS", id, stat)
	// log.Debugln("---")
	// log.Debugln("cpu :", float64(stat.CpuStats.CpuUsage.TotalUsage)/float64(stat.CpuStats.SystemUsage))
	// log.Debugln("ram :", stat.MemoryStats.Usage)

	memPercent := float64(stat.MemoryStats.Usage) / float64(stat.MemoryStats.Limit) * 100.0
	var cpuPercent float64
	if preCPUStats, exists := d.previousCPUStats[id]; exists {
		cpuPercent = calculateCPUPercent(preCPUStats, &stat.CpuStats)
	}

	d.previousCPUStats[id] = &CPUStats{TotalUsage: stat.CpuStats.CpuUsage.TotalUsage, SystemUsage: stat.CpuStats.SystemUsage}

	data := url.Values{
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
		cmd := r.URL.Query().Get("cmd")
		cmd, _ = url.QueryUnescape(cmd)
		arr := strings.Split(cmd, " ")
		if len(arr) > 0 {

			if arr[0] == "docker" {
				arr[0] = d.BinaryName
			}

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

	go func() {
		containers, err := d.Client.ListContainers(true, false, "")

		if err != nil {
			log.Error(err.Error())
			return
		}

		images, err := d.Client.ListImages(true)

		if err != nil {
			log.Error(err.Error())
			return
		}

		for i := 0; i < len(containers); i++ {

			id := containers[i].Id
			info, _ := d.Client.InspectContainer(id)
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
				"action":    {"containerInfos"},
				"id":        {id},
				"name":      {name},
				"imageRepo": {imageRepo},
				"imageTag":  {imageTag},
				"running":   {strconv.FormatBool(info.State.Running)},
			}

			CuberiteServerRequest(data)

			if info.State.Running {
				// Monitor stats
				d.Client.StartMonitorStats(id, d.statCallback, nil)
			}
		}
	}()
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
