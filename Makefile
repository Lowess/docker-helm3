.PHONY: plugin release

VERSION ?= latest
APP ?= helm3
DOCKER_REGISTRY ?= lowess

# Colors
RED = \033[0;31m
GREEN = \033[0;32m
BLUE = \033[0;36m
NC = \033[0m # No Color

build:
	@echo "Building Docker image (export VERSION=<version> if needed)"
	docker build . -t $(DOCKER_REGISTRY)/$(APP):$(VERSION)

	@echo "\n$(BLUE)|- Run it with:$(NC)\n"
	@sed -n '/#--runit--/,/$(DOCKER_REGISTRY)\/$(APP)/p' README.md

push:
	@echo "Pushing Docker image to the registry"
	docker push $(DOCKER_REGISTRY)/$(APP):$(VERSION)
