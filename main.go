package main

import (
	"flag"
	"net/http"
	"os"

	log "github.com/Sirupsen/logrus"
)

var debugFlag = flag.Bool("debug", false, "enable debug logging")
var daemonFlag = flag.Bool("daemon", false, "run the daemon")

func main() {
	flag.Parse()

	if *debugFlag {
		log.SetLevel(log.DebugLevel)
	}

	// goproxy is executed as a short lived process to send a request to the
	// goproxy daemon process
	if !*daemonFlag {
		if err := ProxyCmd(flag.Args()); err != nil {
			log.Fatalf(err.Error())
			os.Exit(1)
		}
		return
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

	// start monitoring docker events
	daemon.Client.StartMonitorEvents(daemon.eventCallback, nil)

	// start a http server and listen on local port 8000
	go func() {
		http.HandleFunc("/containers", daemon.listContainers)
		http.HandleFunc("/exec", daemon.execCmd)
		http.ListenAndServe(":8000", nil)
	}()

	// wait for interruption
	<-make(chan int)
}
