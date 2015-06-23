package main

import (
	"fmt"
	"github.com/samalba/dockerclient"
	"net/http"
	"net/url"
	"strings"
)

// Callback used to listen to Docker's events
func eventCallback(event *dockerclient.Event, ec chan error, args ...interface{}) {
	fmt.Println("---")
	fmt.Printf("%+v\n", *event)

	id := event.Id

	switch event.Status {
	case "create":
		//fmt.Println("create event")
	case "start":
		client := &http.Client{}
		data := url.Values{"action": {"startContainer"}, "id": {id}, "name": {"<name>"}, "imageRepo": {"<imageName>"}, "imageTag": {"<imageTag>"}}
		req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Docker/Docker", strings.NewReader(data.Encode()))
		req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
		req.SetBasicAuth("admin", "admin")
		client.Do(req)
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

func main() {

	// Init the client
	docker, _ := dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)

	// Monitor events
	docker.StartMonitorEvents(eventCallback, nil)

	// wait for interruption
	<-make(chan int)

	// Get only running containers
	/*
		containers, err := docker.ListContainers(false, false, "")
		if err != nil {
			fmt.Println("ERROR:", err.Error())
		}

		client := &http.Client{}

		// list the "already created" containers

		for i := 0; i < len(containers); i++ {

			id := containers[i].Id
			info, _ := docker.InspectContainer(id)
			name := info.Name[1:]
			fmt.Println("id:", id)

			data := url.Values{"action": {"startContainer"}, "id": {id}, "name": {name}, "imageRepo": {"<imageName>"}, "imageTag": {"<imageTag>"}}
			req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Docker/Docker", strings.NewReader(data.Encode()))
			req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
			req.SetBasicAuth("admin", "admin")
			client.Do(req)
		}
	*/

	// connect to docker daemon events and send needed requests to the MC Server
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
