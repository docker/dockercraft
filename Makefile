.PHONY: all test test-local install-deps lint fmt vet build serve

REPO_NAME = dockercraft
REPO_OWNER = docker
PKG_NAME = github.com/${REPO_OWNER}/${REPO_NAME}
IMAGE = golang:1.16
IMAGE_NAME = dockercraft-dev
CONTAINER_NAME = dockercraft-dev-container
PACKAGES=$(shell go list ./... | grep -v vendor)

all: test

test-local:
	@echo "+ $@"
	@go test -v .

test: lint
	@docker run -v $(CURDIR):/go/src/${PKG_NAME} -w /go/src/${PKG_NAME} ${IMAGE} make test-local

lint:
	@echo "+ $@"
	@docker run --rm -v $(CURDIR):/app -w /app golangci/golangci-lint:v1.40.1 golangci-lint run -v

build:
	@echo "+ $@"
	@docker build -t ${IMAGE_NAME} .

serve:
	@docker run -it --rm \
		--name ${CONTAINER_NAME} \
		-p 25565:25565 \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${IMAGE_NAME}
