package main

import (
	"fmt"
	"github.com/samalba/dockerclient"
	"io"
	"net/http"
	"net/url"
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
	case "start":

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

	case "stop":
		fmt.Println("stop event")
	case "restart":
		fmt.Println("restart event")
	case "kill":
		fmt.Println("kill event")
	case "die":
		fmt.Println("die event")
	}
}

func listContainers(w http.ResponseWriter, r *http.Request) {

	containers, err := DOCKER_CLIENT.ListContainers(false, false, "")

	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	images, err := DOCKER_CLIENT.ListImages()

	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	client := &http.Client{}

	for i := 0; i < len(containers); i++ {

		id := containers[i].Id
		info, _ := DOCKER_CLIENT.InspectContainer(id)
		name := info.Name[1:]
		//image := strings.Split(info.Image, ":")
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
			"action": {"startContainer"},
			//"action":    {"containerInfos"},
			"id":        {id},
			"name":      {name},
			"imageRepo": {imageRepo},
			"imageTag":  {imageTag},
			"status":    {strconv.FormatBool(info.State.Running)},
		}

		MCServerRequest(data, client)
	}

	io.WriteString(w, "OK")
}

func main() {

	// Init the client
	DOCKER_CLIENT, _ = dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)

	// Monitor events
	DOCKER_CLIENT.StartMonitorEvents(eventCallback, nil)

	go func() {
		http.HandleFunc("/containers", listContainers)
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
