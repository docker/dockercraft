FROM alpine:3.13 AS wget
RUN apk add --no-cache ca-certificates wget tar

FROM wget AS docker
ARG DOCKER_VERSION=20.10.7
RUN wget -qO- https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | \
  tar -xvz --strip-components=1 -C /bin

FROM wget AS cuberite
ARG CUBERITE_BUILD=239
WORKDIR /srv
RUN wget -qO- "https://builds.cuberite.org/job/linux-x86_64/${CUBERITE_BUILD}/artifact/Cuberite.tar.gz" |\
  tar -xzf -

FROM golang:1.16 AS dockercraft
WORKDIR /go/src/github.com/docker/dockercraft
COPY . .
RUN go install

FROM debian:buster-slim
RUN apt-get update; apt-get install -y ca-certificates
COPY --from=dockercraft /go/bin/dockercraft /bin
COPY --from=docker /bin/docker /bin
COPY --from=cuberite /srv /srv

# Copy Dockercraft config and plugin
COPY ./config /srv
COPY ./docs/img/logo64x64.png /srv/favicon.png
COPY ./Docker /srv/Plugins/Docker

EXPOSE 25565
ENTRYPOINT ["/srv/start.sh"]
