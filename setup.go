package main

import (
	"archive/tar"
	"compress/gzip"
	"io"
	"net/http"
	"os"
	"path"
	"strconv"
	"strings"

	log "github.com/Sirupsen/logrus"
)

const (
	downloadURL   = "https://download.docker.com/linux/static/stable/x86_64/docker-"
	rcDownloadURL = "https://test.docker.com/builds/Linux/x86_64/docker-"
)

// GetDockerBinary ensures that we have the right version docker client
// for communicating with the Docker Daemon
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

		// determine if we're using an RC build of docker
		url := downloadURL
		if strings.Contains(d.Version, "rc") {
			url = rcDownloadURL
		}

		// the method of downloading it is different for version >= 1.11.0
		// (in which case it is an archive containing multiple binaries)
		versionComp, err := compareVersions(d.Version, "1.11.0")
		if err != nil {
			return err
		}
		if versionComp >= 0 {
			err = getClient(out, url+d.Version+".tgz", extractClient)
			if err != nil {
				return err
			}
		} else {
			err = getClient(out, url+d.Version, copyClient)
			if err != nil {
				return err
			}
		}

		err = os.Chmod(filename, 0700)
		if err != nil {
			return err
		}
	} else {
		log.Infof("docker binary (version %s) found!", d.Version)
	}
	return nil
}

// Utility functions

type copier func(out *os.File, resp *http.Response) error

func compareVersions(v1 string, v2 string) (comp int, err error) {
	v1Parts := strings.Split(v1, ".")
	v2Parts := strings.Split(v2, ".")

	for i := 0; i < len(v1Parts) && i < len(v2Parts); i++ {
		v1int, err := strconv.Atoi(v1Parts[i])
		if err != nil {
			return -2, err
		}

		v2int, err := strconv.Atoi(v2Parts[i])
		if err != nil {
			return -2, err
		}

		if v1int < v2int {
			return -1, nil
		} else if v1int > v2int {
			return 1, nil
		}
	}

	if len(v1Parts) < len(v2Parts) {
		return -1, nil
	} else if len(v1Parts) > len(v2Parts) {
		return 1, nil
	}
	return 0, nil
}

func getClient(out *os.File, URL string, cp copier) error {
	resp, err := http.Get(URL)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	err = cp(out, resp)
	return err
}

func copyClient(out *os.File, resp *http.Response) error {
	_, err := io.Copy(out, resp.Body)
	return err
}

func extractClient(out *os.File, resp *http.Response) error {
	gr, err := gzip.NewReader(resp.Body)
	defer gr.Close()
	if err != nil {
		return err
	}

	tr := tar.NewReader(gr)
	for {
		hdr, err := tr.Next()
		if err == io.EOF {
			break
		}
		if err != nil {
			return err
		}

		if hdr.Typeflag == tar.TypeReg && hdr.Name == "docker/docker" {
			_, err = io.Copy(out, tr)
			if err != nil {
				return err
			}
			break
		}
		// logrus.Println("not yet")
	}
	return nil
}
