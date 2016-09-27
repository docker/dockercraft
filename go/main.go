package main

import (
	"flag"
	log "github.com/Sirupsen/logrus"
	"os"
)

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

	daemon.StartMonitoringEvents()

	daemon.Serve()
}
