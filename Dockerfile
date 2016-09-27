FROM golang:1.6

ENV DOCKER_VERSION 1.12.1

# Copy latest docker client(s)
RUN curl -sSL -o docker.tgz https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz &&\
	tar -xvf docker.tgz --strip-components=1 -C /bin && rm docker.tgz &&\
	chmod +x /bin/docker-* &&\
	ln -s /bin/docker /bin/docker-${DOCKER_VERSION}

# Copy Go code and install applications
WORKDIR /go/src/github.com/docker/dockercraft
COPY . .
RUN go install

# Download Cuberite server (Minecraft C++ server)
# and load up a special empty world for Dockercraft
WORKDIR /srv
RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh)" && mv Server cuberite_server
RUN ln -s /srv/cuberite_server/Cuberite /usr/bin/cuberite
COPY ./world world
COPY ./docs/img/logo64x64.png logo.png

COPY ./start.sh start.sh
CMD ["/bin/sh", "/srv/start.sh"]
EXPOSE 25565
