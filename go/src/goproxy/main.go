package main

import (
	"fmt"
	"github.com/samalba/dockerclient"
	"io"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"strconv"
	"strings"
)

var DOCKER_CLIENT *dockerclient.DockerClient

// Callback used to listen to Docker's events
func eventCallback(event *dockerclient.Event, ec chan error, args ...interface{}) {

	fmt.Println("---")
	fmt.Printf("%+v\n", *event)

	client := &http.Client{}

	id := event.Id

	switch event.Status {
	case "create":
		fmt.Println("create event")

		repo, tag := splitRepoAndTag(event.From)

		containerName := "<name>"

		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)

		if err != nil {
			fmt.Print("InspectContainer error:", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"action":    {"createContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		MCServerRequest(data, client)

	case "start":
		fmt.Println("start event")

		repo, tag := splitRepoAndTag(event.From)

		containerName := "<name>"

		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)

		if err != nil {
			fmt.Print("InspectContainer error:", err.Error())
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

		MCServerRequest(data, client)

	case "stop":
		fmt.Println("stop event")

		repo, tag := splitRepoAndTag(event.From)

		containerName := "<name>"

		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)

		if err != nil {
			fmt.Print("InspectContainer error:", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"action":    {"stopContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		MCServerRequest(data, client)

	case "restart":
		fmt.Println("restart event")
		//  same as start event
		repo, tag := splitRepoAndTag(event.From)

		containerName := "<name>"

		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)

		if err != nil {
			fmt.Print("InspectContainer error:", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"action":    {"startContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		MCServerRequest(data, client)

	case "kill":
		fmt.Println("kill event")
		// same as stop event
		repo, tag := splitRepoAndTag(event.From)

		containerName := "<name>"

		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)

		if err != nil {
			fmt.Print("InspectContainer error:", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"action":    {"stopContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		MCServerRequest(data, client)

	case "die":
		fmt.Println("die event")
		// same as stop event
		repo, tag := splitRepoAndTag(event.From)

		containerName := "<name>"

		containerInfo, err := DOCKER_CLIENT.InspectContainer(id)

		if err != nil {
			fmt.Print("InspectContainer error:", err.Error())
		} else {
			containerName = containerInfo.Name
		}

		data := url.Values{
			"action":    {"stopContainer"},
			"id":        {id},
			"name":      {containerName},
			"imageRepo": {repo},
			"imageTag":  {tag}}

		MCServerRequest(data, client)

	case "destroy":
		fmt.Println("destroy event")

		data := url.Values{
			"action": {"destroyContainer"},
			"id":     {id},
		}

		MCServerRequest(data, client)
	}
}

func statCallback(id string, stat *dockerclient.Stats, ec chan error, args ...interface{}) {

	//fmt.Println("STATS", id, stat)

	// fmt.Println("---")
	// fmt.Println("cpu :", float64(stat.CpuStats.CpuUsage.TotalUsage)/float64(stat.CpuStats.SystemUsage))
	// fmt.Println("ram :", stat.MemoryStats.Usage)

	client := &http.Client{}

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

	MCServerRequest(data, client)
}

func execCmd(w http.ResponseWriter, r *http.Request) {

	fmt.Println("*** execCmd (1)")

	io.WriteString(w, "OK")

	go func() {

		fmt.Println("*** execCmd")

		cmd := r.URL.Query().Get("cmd")

		fmt.Println("*** cmd:", cmd)

		cmd, _ = url.QueryUnescape(cmd)

		fmt.Println("*** cmd (unescape):", cmd)

		arr := strings.Split(cmd, " ")

		fmt.Println("*** arr:", arr)

		if len(arr) > 0 {
			cmd := exec.Command(arr[0], arr[1:]...)

			// Stdout buffer
			// cmdOutput := &bytes.Buffer{}
			// Attach buffer to command
			// cmd.Stdout = cmdOutput

			// Execute command
			// printCommand(cmd)
			err := cmd.Run() // will wait for command to return

			if err != nil {
				fmt.Println("Error:", err.Error())
			}

		}
	}()

}

func listContainers(w http.ResponseWriter, r *http.Request) {

	// answer right away to avoid dead locks in LUA
	io.WriteString(w, "OK")

	go func() {
		containers, err := DOCKER_CLIENT.ListContainers(true, false, "")

		if err != nil {
			fmt.Println(err.Error())
			return
		}

		images, err := DOCKER_CLIENT.ListImages()

		if err != nil {
			fmt.Println(err.Error())
			return
		}

		client := &http.Client{}

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

			MCServerRequest(data, client)

			if info.State.Running {
				// Monitor stats
				DOCKER_CLIENT.StartMonitorStats(id, statCallback, nil)
			}
		}
	}()
}

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

type CPUStats struct {
	TotalUsage  uint64
	SystemUsage uint64
}

var previousCPUStats map[string]*CPUStats

func main() {

	previousCPUStats = make(map[string]*CPUStats)

	if len(os.Args) > 1 {

		// If there's an argument
		// It will be considered as a path for an HTTP GET request
		// That's a way to communicate with goproxy daemon

		if len(os.Args) == 2 {
			reqPath := "http://127.0.0.1:8000/" + os.Args[1]

			resp, err := http.Get(reqPath)
			if err != nil {
				fmt.Println("Error on request:", reqPath, "ERROR:", err.Error())
			} else {
				fmt.Println("Request sent", reqPath, "StatusCode:", resp.StatusCode)
			}
		}

		// os.exec in lua will block the script execution
		// it's better to do it in goproxy
		// in lua: `os.exec("goproxy exec PLAYER_NAME docker run...)`
		if len(os.Args) >= 4 && os.Args[1] == "exec" {

			reqPath := "http://127.0.0.1:8000/exec?cmd=" + strings.Join(os.Args[3:], "+")

			resp, err := http.Get(reqPath)
			if err != nil {
				fmt.Println("Error on request:", reqPath, "ERROR:", err.Error())
			} else {
				fmt.Println("Request sent", reqPath, "StatusCode:", resp.StatusCode)
			}
		}

		return
	}

	// Init the client
	DOCKER_CLIENT, _ = dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)

	// Monitor events
	DOCKER_CLIENT.StartMonitorEvents(eventCallback, nil)

	go func() {
		http.HandleFunc("/containers", listContainers)
		http.HandleFunc("/exec", execCmd)
		http.ListenAndServe(":8000", nil)
	}()

	// wait for interruption
	<-make(chan int)
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

// MCServerRequest send a POST request that will be handled
// by our MCServer Docker plugin.
func MCServerRequest(data url.Values, client *http.Client) {

	if client == nil {
		client = &http.Client{}
	}

	req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Docker/Docker", strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	client.Do(req)
}
