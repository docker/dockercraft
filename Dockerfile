FROM golang:1.5.1

ADD ./cuberite_server /srv/cuberite_server
ADD ./world /srv/world
ADD ./docs/img/logo64x64.png /srv/logo.png
ADD ./start.sh /srv/start.sh
ADD ./go /go
ADD ./docker_linux_x64/docker /bin/docker

RUN chmod +x /bin/docker
RUN cd /go/src/goproxy; go install

CMD ["/bin/bash","/srv/start.sh"]
