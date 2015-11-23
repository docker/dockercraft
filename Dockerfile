FROM golang:1.5.1

ENV GO15VENDOREXPERIMENT=1

ADD ./cuberite_server /srv/cuberite_server
ADD ./world /srv/world
ADD ./docs/img/logo64x64.png /srv/logo.png
ADD ./start.sh /srv/start.sh
ADD ./docker_linux_x64/docker /bin/docker

RUN chmod +x /bin/docker

WORKDIR /go/src/github.com/docker/dockercraft
ADD ./goproxy goproxy
ADD ./vendor vendor
RUN go install ./goproxy

CMD ["/bin/bash","/srv/start.sh"]
