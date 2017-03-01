FROM golang:1.7.1

ENV DOCKER_VERSION 1.12.1
ENV CUBERITE_BUILD 630

# Copy latest docker client(s)
RUN curl -sSL -o docker.tgz https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz &&\
	tar -xvf docker.tgz --strip-components=1 -C /bin && rm docker.tgz &&\
	chmod +x /bin/docker-* &&\
	ln -s /bin/docker /bin/docker-${DOCKER_VERSION}

# Download Cuberite server (Minecraft C++ server)
WORKDIR /srv
RUN curl "https://builds.cuberite.org/job/Cuberite Linux x64 Master/${CUBERITE_BUILD}/artifact/Cuberite.tar.gz" | tar -xzf -

# Copy Dockercraft config and plugin
COPY ./config /srv/Server
COPY ./docs/img/logo64x64.png /srv/Server/favicon.png
COPY ./Docker /srv/Server/Plugins/Docker

# Copy Go code and install
WORKDIR /go/src/github.com/docker/dockercraft
COPY . .
RUN go install

EXPOSE 25565

ENTRYPOINT ["/srv/Server/start.sh"]

