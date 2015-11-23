IMAGE_NAME=dockercraft-dev
CONTAINER_NAME=dockercraft-dev-container

PKGS="./goproxy"

.PHONY: all build serve validate fmt lint vet

all: validate build

build:
	@echo "+ $@"
	@docker build -t ${IMAGE_NAME} .

serve:
	@docker run -it --rm \
		--name ${CONTAINER_NAME} \
		-p 25566:25565 \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${IMAGE_NAME}

validate: fmt lint vet

fmt:
	@echo "+ $@"
	@test -z "$$(gofmt -s -l . 2>&1 | grep -v vendor/ | tee /dev/stderr)"

lint:
	@echo "+ $@"
	@test -z "$$(golint ${PKGS} | tee /dev/stderr)"

vet:
	@echo "+ $@"
	@go vet ${PKGS}
