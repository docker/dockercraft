package main

import (
	"io"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"strconv"
	"strings"

	"github.com/Sirupsen/logrus"
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

// instance of DockerClient allowing for making calls to the docker daemon
// remote API
var DOCKER_CLIENT *dockerclient.DockerClient
var DOCKER_DAEMON_VERSION string

type CPUStats struct {
	TotalUsage  uint64
	SystemUsage uint64
}

// previousCPUStats is a map containing the previous CPU stats we got from the 
// docker daemon through the docker remote API
var previousCPUStats map[string]*CPUStats = make(map[string]*CPUStats)

func main() {

	// goproxy is executed as a short lived process to send a request to the
	// goproxy daemon process
	if len(os.Args) > 1 {
		// If there's an argument
		// It will be considered as a path for an HTTP GET request
		// That's a way to communicate with goproxy daemon
		if len(os.Args) == 2 {
			reqPath := "http://127.0.0.1:8000/" + os.Args[1]
			resp, err := http.Get(reqPath)
			if err != nil {
				logrus.Println("Error on request:", reqPath, "ERROR:", err.Error())
			} else {
				logrus.Println("Request sent", reqPath, "StatusCode:", resp.StatusCode)
			}
		}
		return
	}

	// init docker client object
	var err error
	DOCKER_CLIENT, err = dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)
	if err != nil {
		logrus.Fatal(err.Error())
	}

	// get the version of the docker remote API
	version, err := DOCKER_CLIENT.Version()
	if err != nil {
		logrus.Fatal(err.Error())
	}
	DOCKER_DAEMON_VERSION = version.Version

	// start monitoring docker events
	DOCKER_CLIENT.StartMonitorEvents(eventCallback, nil)

	// start a http server and listen on local port 8000
	go func() {
		http.HandleFunc("/containers", listContainers)
		http.HandleFunc("/exec", execCmd)
		http.ListenAndServe(":8000", nil)
	}()

	// wait for interruption
	<-make(chan int)
}

// eventCallback receives and handles the docker events
func eventCallback(event *dockerclient.Event, ec chan error, args ...interface{}) {
	logrus.Debugln("--\n%+v", *event)

	id := event.Id

	switch event.Status {
	case "create":
		logrus.Debugln("create event")

		repo, tag := splitRepoAndTag(event.From)
		containerName := "<name>"
		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)
		if err != nil {
			logrus.Print("InspectContainer error:", err.Error())
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
		logrus.Debugln("start event")

		repo, tag := splitRepoAndTag(event.From)
		containerName := "<name>"
		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)
		if err != nil {
			logrus.Print("InspectContainer error:", err.Error())
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
		DOCKER_CLIENT.StartMonitorStats(id, statCallback, nil)
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
		logrus.Debugln("die event")

		// same as stop event
		repo, tag := splitRepoAndTag(event.From)
		containerName := "<name>"
		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)
		if err != nil {
			logrus.Print("InspectContainer error:", err.Error())
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
		logrus.Debugln("destroy event")

		data := url.Values{
			"action": {"destroyContainer"},
			"id":     {id},
		}

		CuberiteServerRequest(data)
	}
}

// statCallback receives the stats (cpu & ram) from containers and send them to
// the cuberite server
func statCallback(id string, stat *dockerclient.Stats, ec chan error, args ...interface{}) {

	// logrus.Debugln("STATS", id, stat)
	// logrus.Debugln("---")
	// logrus.Debugln("cpu :", float64(stat.CpuStats.CpuUsage.TotalUsage)/float64(stat.CpuStats.SystemUsage))
	// logrus.Debugln("ram :", stat.MemoryStats.Usage)

	memPercent := float64(stat.MemoryStats.Usage) / float64(stat.MemoryStats.Limit) * 100.0
	var cpuPercent float64 = 0.0
	if preCPUStats, exists := previousCPUStats[id]; exists {
		cpuPercent = calculateCPUPercent(preCPUStats, &stat.CpuStats)
	}

	previousCPUStats[id] = &CPUStats{TotalUsage: stat.CpuStats.CpuUsage.TotalUsage, SystemUsage: stat.CpuStats.SystemUsage}

	data := url.Values{
		"action": {"stats"},
		"id":     {id},
		"cpu":    {strconv.FormatFloat(cpuPercent, 'f', 2, 64) + "%"},
		"ram":    {strconv.FormatFloat(memPercent, 'f', 2, 64) + "%"}}

	CuberiteServerRequest(data)
}

// execCmd handles http requests received for the path "/exec"
func execCmd(w http.ResponseWriter, r *http.Request) {

	io.WriteString(w, "OK")

	go func() {
		cmd := r.URL.Query().Get("cmd")
		cmd, _ = url.QueryUnescape(cmd)
		arr := strings.Split(cmd, " ")
		if len(arr) > 0 {

			if arr[0] == "docker" {
				arr[0] = "docker-" + DOCKER_DAEMON_VERSION
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
				logrus.Println("Error:", err.Error())
			}
		}
	}()
}

// listContainers handles and reply to http requests having the path "/containers"
func listContainers(w http.ResponseWriter, r *http.Request) {

	// answer right away to avoid dead locks in LUA
	io.WriteString(w, "OK")

	go func() {
		containers, err := DOCKER_CLIENT.ListContainers(true, false, "")

		if err != nil {
			logrus.Println(err.Error())
			return
		}

		images, err := DOCKER_CLIENT.ListImages(true)

		if err != nil {
			logrus.Println(err.Error())
			return
		}

		for i := 0; i < len(containers); i++ {

			id := containers[i].Id
			info, _ := DOCKER_CLIENT.InspectContainer(id)
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
				DOCKER_CLIENT.StartMonitorStats(id, statCallback, nil)
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
