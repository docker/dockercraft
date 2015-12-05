package main

import (
	"io"
	"net/http"
	"os"
	"path"

	log "github.com/Sirupsen/logrus"
)

func (d *Daemon) GetDockerBinary() error {
	// name of docker binary that is needed
	d.BinaryName = "docker-" + d.Version
	log.Infof("looking for docker binary named: %s", d.BinaryName)

	filename := path.Join("/bin", d.BinaryName)

	if _, err := os.Stat(filename); os.IsNotExist(err) {

		log.Infof("docker binary (version %s) not found.", d.Version)
		log.Infof("downloading %s...", d.BinaryName)

		out, err := os.Create(filename)
		if err != nil {
			return err
		}
		defer out.Close()
		resp, err := http.Get("https://get.docker.com/builds/Linux/x86_64/" + d.BinaryName)
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
		log.Info("docker binary (version %s) found!", d.Version)
	}
	return nil
}
