package main

import (
	"archive/tar"
	"compress/gzip"
	"github.com/Sirupsen/logrus"
	"github.com/samalba/dockerclient"
	"io"
	"net/http"
	"os"
	"path"
)

// instance of DockerClient allowing for making calls to the docker daemon
// remote API
var dockerClient *dockerclient.DockerClient

func main() {

	// init docker client object
	var err error
	dockerClient, err = dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)
	if err != nil {
		logrus.Fatal(err.Error())
	}

	// get the version of the docker daemon so we can be sure the corresponding
	// docker client is installed and install it if necessary
	version, err := dockerClient.Version()
	if err != nil {
		logrus.Fatal(err.Error())
	}
	dockerDaemonVersion := version.Version

	// name of docker binary that is needed
	dockerBinaryName := "docker-" + dockerDaemonVersion
	logrus.Println("looking for docker binary named:", dockerBinaryName)

	filename := path.Join("/bin", dockerBinaryName)

	if _, err := os.Stat(filename); os.IsNotExist(err) {

		logrus.Println("docker binary (version " + dockerDaemonVersion + ") not found.")
		logrus.Println("downloading", dockerBinaryName, "...")

		out, err := os.Create(filename)
		if err != nil {
			logrus.Fatal(err.Error())
		}
		defer out.Close()
		resp, err := http.Get("https://get.docker.com/builds/Linux/x86_64/docker-" + dockerDaemonVersion + ".tgz")
		if err != nil {
			logrus.Fatal(err.Error())
		}
		defer resp.Body.Close()

		gr, err := gzip.NewReader(resp.Body)
		defer gr.Close()
		if err != nil {
			logrus.Fatal(err.Error())
		}

		tr := tar.NewReader(gr)
		for {
			hdr, err := tr.Next()
			if err == io.EOF {
				break
			}
			if err != nil {
				logrus.Fatal(err.Error())
			}

			if hdr.Typeflag == tar.TypeReg && hdr.Name == "docker/docker" {
				_, err = io.Copy(out, tr)
				if err != nil {
					logrus.Fatal(err.Error())
				}
				break
			}
			logrus.Println("not yet")
		}

		err = os.Chmod(filename, 0700)
		if err != nil {
			logrus.Fatal(err.Error())
		}
	}
}
