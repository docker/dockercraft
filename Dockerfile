FROM golang:1.5.1

RUN go get github.com/tools/godep

# Copy latest docker client(s)
COPY ./docker/docker-1.9.1 /bin/docker-1.9.1
RUN chmod +x /bin/docker-*

# Copy Go code and install applications
WORKDIR /go/src/github.com/docker/dockercraft
COPY . .
RUN godep go install

# Download Cuberite server (Minecraft C++ server)
# and load up a special empty world for Dockercraft
WORKDIR /srv
RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh)" && mv Server cuberite_server
COPY ./world world
COPY ./docs/img/logo64x64.png logo.png

COPY ./start.sh start.sh
CMD ["/bin/bash","/srv/start.sh"]
