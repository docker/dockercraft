package main

import (
	"flag"
	log "github.com/Sirupsen/logrus"
	"os"
)

// The main purpose of this application is to connect the docker daemon
// (remote API) and the custom Minecraft server (cubrite using lua scripts).
// Docker daemons events are transmitted to the LUA script as JSON messages
// over TCP transport. The cuberite LUA scripts can also contact this
// application over the same TCP connection.

var debugFlag = flag.Bool("debug", false, "enable debug logging")

func main() {
	flag.Parse()

	if *debugFlag {
		log.SetLevel(log.DebugLevel)
	}

	daemon := NewDaemon()
	if err := daemon.Init(); err != nil {
		log.Fatal(err.Error())
		os.Exit(1)
	}

	if err := daemon.GetDockerBinary(); err != nil {
		log.Fatal(err.Error())
		os.Exit(1)
	}

	go daemon.StartMonitoringEvents()

	daemon.Serve()
}
