# Makefile for building and running NAPE Containers

# Variables (no default values)
# IMAGE       - Name of the Docker image (required)
# CONTAINER   - Name of the Docker container (required)
# DOCKERFILE  - Path to the Dockerfile (required for build, rebuild)

# Default target
.PHONY: help
help:
	@echo ""
	@echo "Makefile Usage:"
	@echo ""
	@echo "  make build IMAGE=<IMAGE> DOCKERFILE=<DOCKERFILE>                 - Build the Docker image."
	@echo "  make run IMAGE=<IMAGE> CONTAINER=<CONTAINER>                     - Run the Docker container interactively."
	@echo "  make clean IMAGE=<IMAGE> CONTAINER=<CONTAINER>                   - Remove the Docker image and container."
	@echo "  make stop CONTAINER=<CONTAINER>                                  - Stop the running container."
	@echo "  make remove CONTAINER=<CONTAINER>                                - Remove the stopped container."
	@echo "  make rebuild IMAGE=<IMAGE> DOCKERFILE=<DOCKERFILE> CONTAINER=<CONTAINER> - Clean and rebuild the Docker image."
	@echo ""
	@echo "Required Variables:"
	@echo "  IMAGE       - Name of the Docker image (required for build, run, clean, rebuild)."
	@echo "  CONTAINER   - Name of the Docker container (required for run, stop, remove, clean, rebuild)."
	@echo "  DOCKERFILE  - Path to the Dockerfile (required for build, rebuild)."
	@echo ""
	@echo "Example:"
	@echo "  make build IMAGE=my-image DOCKERFILE=path/to/Dockerfile"
	@echo "  make run IMAGE=my-image CONTAINER=my-container"

# Build the Docker image
.PHONY: build
build:
ifndef IMAGE
	$(error IMAGE is not set. Please provide IMAGE variable.)
endif
ifndef DOCKERFILE
	$(error DOCKERFILE is not set. Please provide DOCKERFILE variable.)
endif
	docker build -t $(IMAGE) -f $(DOCKERFILE) $(dir $(DOCKERFILE))

# Run the Docker container interactively
.PHONY: run
run:
ifndef IMAGE
	$(error IMAGE is not set. Please provide IMAGE variable.)
endif
ifndef CONTAINER
	$(error CONTAINER is not set. Please provide CONTAINER variable.)
endif
	docker run -it --name $(CONTAINER) $(IMAGE)

# Stop the running container
.PHONY: stop
stop:
ifndef CONTAINER
	$(error CONTAINER is not set. Please provide CONTAINER variable.)
endif
	docker stop $(CONTAINER) || true

# Remove the stopped container
.PHONY: remove
remove:
ifndef CONTAINER
	$(error CONTAINER is not set. Please provide CONTAINER variable.)
endif
	docker rm $(CONTAINER) || true

# Remove the Docker image
.PHONY: remove-image
remove-image:
ifndef IMAGE
	$(error IMAGE is not set. Please provide IMAGE variable.)
endif
	docker rmi $(IMAGE) || true

# Clean up the Docker image and container
.PHONY: clean
clean: stop remove remove-image

# Rebuild the Docker image
.PHONY: rebuild
rebuild: clean build