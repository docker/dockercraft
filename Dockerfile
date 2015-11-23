FROM golang:1.5.1

COPY ./cuberite_server /srv/cuberite_server
COPY ./world /srv/world
COPY ./docs/img/logo64x64.png /srv/logo.png
COPY ./start.sh /srv/start.sh
COPY ./go /go

# download latest docker client
ADD https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 /bin/docker-1.9.1

RUN chmod +x /bin/docker-*
RUN cd /go/src/goproxy; go install
RUN cd /go/src/gosetup; go install

CMD ["/bin/bash","/srv/start.sh"]
