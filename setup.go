package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path"

	log "github.com/Sirupsen/logrus"
)

// GetDockerBinaries gets the binaries for every registered machine
func (d *Daemon) GetDockerBinaries() error {
	if len(d.Machines) == 0 {
		return fmt.Errorf("No machines found")
	}

	for _, machine := range d.Machines {
		if err := machine.GetDockerBinary(); err != nil {
			return err
		}
	}
	return nil
}

// GetDockerBinary ensures that we have the right version docker client
// for communicating with the Docker Daemon
func (m *Machine) GetDockerBinary() error {
	// name of docker binary that is needed
	m.BinaryName = "docker-" + m.Version
	log.Infof("looking for docker binary named: %s", m.BinaryName)

	filename := path.Join("/bin", m.BinaryName)

	if _, err := os.Stat(filename); os.IsNotExist(err) {

		log.Infof("docker binary (version %s) not found.", m.Version)
		log.Infof("downloading %s...", m.BinaryName)

		out, err := os.Create(filename)
		if err != nil {
			return err
		}
		defer out.Close()
		resp, err := http.Get("https://get.docker.com/builds/Linux/x86_64/" + m.BinaryName)
		if err != nil {
			return err
		}
		defer resp.Body.Close()

		_, err = io.Copy(out, resp.Body)
		if err != nil {
			return err
		}

		err = os.Chmod(filename, 0700)
		if err != nil {
			return err
		}
	} else {
		log.Infof("docker binary (version %s) found!", m.Version)
	}
	return nil
}
