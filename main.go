package main

import (
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"text/template"

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
		log.Fatalf("Init error: %s", err.Error())
		os.Exit(1)
	}

	if err := daemon.GetDockerBinaries(); err != nil {
		log.Fatal(err.Error())
		os.Exit(1)
	}

	type Config struct {
		DefaultWorld string
		Worlds       []string
	}

	config := Config{}
	for name, machine := range daemon.Machines {
		// start monitoring docker events
		machine.Client.StartMonitorEvents(machine.eventCallback, nil)
		// create a new world
		log.Debug("Copying world")
		if err := copyDir("/srv/world/world_template", fmt.Sprintf("/srv/world/%s", name)); err != nil {
			log.Warn(err)
		}
		config.Worlds = append(config.Worlds, name)
	}

	if len(config.Worlds) > 0 {
		// Select default world
		local := -1
		def := -1

		for i := range config.Worlds {
			if config.Worlds[i] == "local" {
				local = i
			}
			if config.Worlds[i] == "default" {
				def = i
			}
		}

		if local > -1 {
			config.DefaultWorld = "local"
			config.Worlds = append(config.Worlds[:local], config.Worlds[local+1:]...)
		} else if def > -1 {
			config.DefaultWorld = "default"
			config.Worlds = append(config.Worlds[:def], config.Worlds[def+1:]...)
		} else {
			config.DefaultWorld = config.Worlds[0]
			config.Worlds = append(config.Worlds[:0], config.Worlds[1:]...)
		}
	} else {
		config.DefaultWorld = config.Worlds[0]
		config.Worlds = nil
	}

	log.Debug("Writing settings.ini")
	t, err := template.ParseFiles("/srv/world/settings.ini.tmpl")
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
	f, err := os.OpenFile("/srv/world/settings.ini", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0777)
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
	err = t.Execute(f, config)
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}

	// start a http server and listen on local port 8000
	go func() {
		log.Info("Starting HTTP Server")
		http.HandleFunc("/containers", daemon.listContainers)
		http.HandleFunc("/exec", daemon.execCmd)
		http.ListenAndServe(":8000", nil)
	}()

	os.Chdir("/srv/world")
	cmd := exec.Command("cuberite")
	//	cmd.Stdin = os.Stdin

	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		log.Fatalf("Error: %s", err)
		os.Exit(1)
	}

	// wait for interruption
	<-make(chan int)
}

func copyDir(source string, dest string) (err error) {

	// get properties of source dir
	sourceinfo, err := os.Stat(source)
	if err != nil {
		return err
	}

	// create dest dir

	err = os.MkdirAll(dest, sourceinfo.Mode())
	if err != nil {
		return err
	}

	directory, _ := os.Open(source)

	objects, err := directory.Readdir(-1)

	for _, obj := range objects {

		sourcefilepointer := source + "/" + obj.Name()

		destinationfilepointer := dest + "/" + obj.Name()

		if obj.IsDir() {
			// create sub-directories - recursively
			err = copyDir(sourcefilepointer, destinationfilepointer)
			if err != nil {
				fmt.Println(err)
			}
		} else {
			// perform copy
			err = copyFile(sourcefilepointer, destinationfilepointer)
			if err != nil {
				fmt.Println(err)
			}
		}

	}
	return
}

func copyFile(source string, dest string) (err error) {
	sourcefile, err := os.Open(source)
	if err != nil {
		return err
	}

	defer sourcefile.Close()

	destfile, err := os.Create(dest)
	if err != nil {
		return err
	}

	defer destfile.Close()

	_, err = io.Copy(destfile, sourcefile)
	if err == nil {
		sourceinfo, err := os.Stat(source)
		if err != nil {
			err = os.Chmod(dest, sourceinfo.Mode())
		}

	}

	return
}
