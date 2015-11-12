FROM golang:1.5.1

ADD ./cuberite_server /srv/cuberite_server
ADD ./world /srv/world
ADD ./start.sh /srv/start.sh
ADD ./go /go
ADD ./docker_linux_x64/docker /docker

RUN chmod +x /docker
RUN cd /go/src/goproxy; go install

CMD ["/bin/bash","/srv/start.sh"]