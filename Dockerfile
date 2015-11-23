FROM golang:1.5.1

# Copy latest docker client(s)
COPY ./docker/docker-1.9.1 /bin/docker-1.9.1
RUN chmod +x /bin/docker-*

# Copy Go code and install applications
COPY ./go /go
RUN cd /go/src/goproxy; go install
RUN cd /go/src/gosetup; go install

# Copy Cuberite server (Minecraft C++ server)
# with special empty world for Dockercraft
COPY ./cuberite_server /srv/cuberite_server
COPY ./world /srv/world
COPY ./docs/img/logo64x64.png /srv/logo.png

COPY ./start.sh /srv/start.sh
CMD ["/bin/bash","/srv/start.sh"]
