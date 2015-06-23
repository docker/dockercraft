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

// Callback used to listen to Docker's events
func eventCallback(event *dockerclient.Event, ec chan error, args ...interface{}) {

	fmt.Println("---")
	fmt.Printf("%+v\n", *event)

	client := &http.Client{}

	id := event.Id

	switch event.Status {
	case "create":
		//fmt.Println("create event")
	case "start":

		data := url.Values{
			"action":    {"startContainer"},
			"id":        {id},
			"name":      {"<name>"},
			"imageRepo": {"<imageName>"},
			"imageTag":  {"<imageTag>"}}

		MCServerRequest(data, client)

	case "stop":
		//fmt.Println("")
	case "restart":
		//fmt.Println("")
	case "kill":
		//fmt.Println("")
	case "die":
		//fmt.Println("")
	}
}

func listContainers(w http.ResponseWriter, r *http.Request) {

	fmt.Println("listContainers(1)")

	docker, _ := dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)
	containers, err := docker.ListContainers(false, false, "")

	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	fmt.Println("listContainers(2)")

	images, err := docker.ListImages()

	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	client := &http.Client{}

	for i := 0; i < len(containers); i++ {

		id := containers[i].Id
		info, _ := docker.InspectContainer(id)
		name := info.Name[1:]
		//image := strings.Split(info.Image, ":")
		imageRepo := ""
		imageTag := ""

		for _, image := range images {
			if image.Id == info.Image {
				if len(image.RepoTags) > 0 {
					repoAndTag := strings.Split(image.RepoTags[0], ":")

					if len(repoAndTag) > 0 {
						imageRepo = repoAndTag[0]
					}

					if len(repoAndTag) > 1 {
						imageTag = repoAndTag[1]
					}
				}
				break
			}
		}

		fmt.Println("listContainers(3)")

		data := url.Values{
			"action": {"startContainer"},
			//"action":    {"containerInfos"},
			"id":        {id},
			"name":      {name},
			"imageRepo": {imageRepo},
			"imageTag":  {imageTag},
			"status":    {strconv.FormatBool(info.State.Running)},
		}

		fmt.Println("listContainers(4)")

		MCServerRequest(data, client)
	}

	io.WriteString(w, "OK")
}

func main() {

	http.HandleFunc("/containers", listContainers)
	http.ListenAndServe(":8000", nil)

	// Init the client
	docker, _ := dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)

	// Monitor events
	docker.StartMonitorEvents(eventCallback, nil)

	// wait for interruption
	<-make(chan int)
}

// MCServerRequest send a POST request that will be handled
// by our MCServer Docker plugin.
func MCServerRequest(data url.Values, client *http.Client) {

	fmt.Println("MCServerRequest (1)")

	if client == nil {
		client = &http.Client{}
	}

	fmt.Println("MCServerRequest (2)")

	req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Docker/Docker", strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	client.Do(req)

	fmt.Println("MCServerRequest (3)")
}
