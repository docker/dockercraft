package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"sync"

	"github.com/Jeffail/gabs"
	log "github.com/Sirupsen/logrus"
	"github.com/samalba/dockerclient"
)

const machineDir = "/root/.docker/machine/machines/"

// Machine contains information about a discovered Docker Machine
type Machine struct {
	// Name is the name of the machine
	Name string
	// Client is a map of Machine names to DockerClient instances
	Client *dockerclient.DockerClient
	// URL is the url that the DockerClient should use for connecting to the daemon
	URL string
	// TLSConfig is the tls config
	TLSConfig *tls.Config
	// Version is the version of the Docker Daemon
	Version string
	// BinaryName is the name of the Docker Binary
	BinaryName string
	// previouscpustats is a map containing the previous cpu stats we got from the
	// docker daemon through the docker remote api
	previousCPUStats     map[string]*CPUStats
	previousCPUStatsLock sync.RWMutex
	// the following are needed to provide the args for Docker CLI
	caCertPath, serverCertPath, serverKeyPath string
}

// NewMachine creates a new Machine object
func NewMachine(name string) *Machine {
	return &Machine{Name: name, previousCPUStats: make(map[string]*CPUStats)}
}

// GetDockerConfig generates the necessary config variables for using the Docker CLI
// This is a hack and should be replaced by Lua parsing the command in to the correct JSON format
// and the proxy should simply send this to the right daemon
func (m *Machine) GetDockerConfig() []string {
	var config []string
	if m.caCertPath != "" {
		config = []string{
			"--tlsverify",
			fmt.Sprintf("--tlscacert=\"%s\"", m.caCertPath),
			fmt.Sprintf("--tlscert=\"%s\"", m.serverCertPath),
			fmt.Sprintf("--tlskey=\"%s\"", m.serverKeyPath),
		}
	}
	config = append(config, "-H", m.URL)
	return config
}

// GetMachines will populate a list of machines
func (d *Daemon) GetMachines() error {
	if _, err := os.Stat("/var/run/docker.sock"); os.IsNotExist(err) {
		log.Warn("No docker socket mounted")
	} else {
		machine := NewMachine("local")
		machine.URL = "unix:///var/run/docker.sock"
		d.Machines["local"] = machine
	}

	log.Info("Looking for Docker Machine VMs...")
	folders, err := ioutil.ReadDir(machineDir)
	if err != nil {
		return err
	}
	for _, f := range folders {
		configFileName := filepath.Join(machineDir, f.Name(), "config.json")
		configFile, err := ioutil.ReadFile(configFileName)
		if err != nil {
			log.Warnf("Failed to open %s", configFile)
			continue
		}
		config, err := gabs.ParseJSON(configFile)
		if err != nil {
			log.Warnf("Error parsing file. %s", err)
			continue
		}
		name, ok := config.Path("Name").Data().(string)
		if !ok {
			log.Warn("Couldn't get machine name")
			continue
		}
		ip, ok := config.Path("Driver.IPAddress").Data().(string)
		if !ok {
			log.Warn("Couldn't get machine IP Address")
			continue
		}
		caCertPath := config.Path("HostOptions.AuthOptions.CaCertPath").Data().(string)
		if !ok {
			log.Warn("Couldn't get machine CA Cert Path")
			continue
		}
		serverCertPath := config.Path("HostOptions.AuthOptions.ServerCertPath").Data().(string)
		if !ok {
			log.Warn("Couldn't get machine Server Cert Path")
			continue
		}
		serverKeyPath := config.Path("HostOptions.AuthOptions.ServerKeyPath").Data().(string)
		if !ok {
			log.Warn("Couldn't get machine Server Key")
			continue
		}

		// No IP == VM has stopped
		if ip == "" {
			continue
		}

		url := fmt.Sprintf("tcp://%s:2376", ip)

		tlsConfig, err := configureTLS(caCertPath, serverCertPath, serverKeyPath)
		if err != nil {
			log.Warnf("Error setting up TLS: %s", err)
			continue
		}

		machine := NewMachine(name)
		machine.URL = url
		machine.TLSConfig = tlsConfig
		machine.caCertPath = rewritePath(caCertPath)
		machine.serverCertPath = rewritePath(serverCertPath)
		machine.serverKeyPath = rewritePath(serverKeyPath)
		d.Machines[name] = machine
		log.Infof("Discovered Machine %s", name)
	}
	return nil
}

func rewritePath(path string) string {
	re := regexp.MustCompile("^/Users/[\\w ]+")
	return re.ReplaceAllString(path, "/root")
}

func configureTLS(caCertPath, serverCertPath, serverKeyPath string) (*tls.Config, error) {
	var tlsConfig *tls.Config

	caCert, err := ioutil.ReadFile(rewritePath(caCertPath))
	if err != nil {
		return tlsConfig, err
	}

	serverCert, err := ioutil.ReadFile(rewritePath(serverCertPath))
	if err != nil {
		return tlsConfig, err
	}

	serverKey, err := ioutil.ReadFile(rewritePath(serverKeyPath))
	if err != nil {
		return tlsConfig, err
	}

	certPool := x509.NewCertPool()
	ok := certPool.AppendCertsFromPEM(caCert)
	if !ok {
		return tlsConfig, err
	}

	keypair, err := tls.X509KeyPair(serverCert, serverKey)
	if err != nil {
		return tlsConfig, err
	}

	tlsConfig = &tls.Config{
		RootCAs:            certPool,
		InsecureSkipVerify: false,
		Certificates:       []tls.Certificate{keypair},
	}

	return tlsConfig, nil
}
