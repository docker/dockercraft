package main

import (
	"fmt"
	"github.com/samalba/dockerclient"
	"net/http"
	"net/url"
	"strings"
)

func main() {

	// Init the client
	docker, _ := dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)

	// Get only running containers
	containers, err := docker.ListContainers(false, false, "")
	if err != nil {
		// log.Fatal(err)
		fmt.Println("ERROR:", err.Error())
	}

	client := &http.Client{}

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
