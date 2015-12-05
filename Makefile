.PHONY: all test test-local install-deps lint fmt vet build serve

REPO_NAME = dockercraft
REPO_OWNER = docker
PKG_NAME = github.com/${REPO_OWNER}/${REPO_NAME}
IMAGE = golang:1.6
IMAGE_NAME = dockercraft-dev
CONTAINER_NAME = dockercraft-dev-container

all: test build

test-local: install-deps fmt lint vet
	@echo "+ $@"
	@go test -v .
test:
	@docker run -v ${shell pwd}:/go/src/${PKG_NAME} -w /go/src/${PKG_NAME} ${IMAGE} make test-local

install-deps:
	@echo "+ $@"
	@go get -u github.com/golang/lint/golint
	@apt-get -qq update && apt-get -qq -y install lua5.1

lint:
	@echo "+ $@"
	@test -z "$$(golint ./... | grep -v vendor/ | tee /dev/stderr)"

fmt:
	@echo "+ $@"
	@test -z "$$(gofmt -s -l . | grep -v vendor/ | tee /dev/stderr)"
	@luac -p ./world/Plugins/Docker/*.lua

vet:
	@echo "+ $@"
	@go vet .

build:
	@echo "+ $@"
	@docker build -t ${IMAGE_NAME} .

serve:
	@docker run -it --rm \
		--name ${CONTAINER_NAME} \
		-p 8080:8080 \
		-p 25566:25565 \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /Users/$$USER/.docker/machine:/root/.docker/machine \
		${IMAGE_NAME} -debug
