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
	"strings"
	"strconv"
)

const (
	baseURL = "https://get.docker.com/builds/Linux/x86_64"
)

// instance of DockerClient allowing for making calls to the docker daemon
// remote API
var dockerClient *dockerclient.DockerClient

type copier func(out *os.File, resp *http.Response)

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

		versionComp, err := CompareVersions(dockerDaemonVersion, "1.11.0");
		if err != nil {
			logrus.Fatal(err.Error())
		}

		if versionComp >= 0 {
			getClient(out,"https://get.docker.com/builds/Linux/x86_64/docker-" + dockerDaemonVersion + ".tgz", extractClient)
		} else {
			getClient(out,"https://get.docker.com/builds/Linux/x86_64/docker-" + dockerDaemonVersion, copyClient)
		}

		err = os.Chmod(filename, 0700)
		if err != nil {
			logrus.Fatal(err.Error())
		}
	}
}

func CompareVersions(v1 string, v2 string) (comp int, err error) {
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


func copyClient(out *os.File, resp *http.Response) {
	_, err := io.Copy(out, resp.Body)
	if err != nil {
		logrus.Fatal(err.Error())
	}
}

func extractClient(out *os.File, resp *http.Response) {
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
}

func getClient(out *os.File, URL string, cp copier) {
	resp, err := http.Get(URL)
	if err != nil {
		logrus.Fatal(err.Error())
	}
	defer resp.Body.Close()
	cp(out, resp)
}
