## -----------------------------------------------------------------------------------------------
## This is the Makefile which contains the recipies that define how to interact with the
## repository's YAML files. Is is sort of a habit of mine to create a Makefile.
## 
## ----------------------------------------- Variables -----------------------------------------
## Required Vars: The variables required when deploying to a remote registry.
## - CONTAINER_REGISTRY: Expected to be passed from the running pipeline
## - VERSION: Cannot be set to "local" when deploying remotely.
## - IMAGE_NAME: The name of the image to be pushed to the container registry.
## - SCAN_IMAGE: Whether to scan the image for vulnerabilities after the build.
##
CONTAINER_REGISTRY ?= docker.io/usersina
IMAGE_NAME = sqldeveloper
VERSION ?= local
SCAN_IMAGE = false
## 
## Computed Vars: They are used internally, prefixed by "CV_" and should not be changed!
CV_LOCAL_TAG = $(IMAGE_NAME):$(VERSION)# e.g. app-example-1:latest
CV_REMOTE_TAG = $(CONTAINER_REGISTRY)/$(CV_LOCAL_TAG)# e.g.  docker.io/usersina/app-example-1:latest
CV_ZIP_EXISTS = $(shell test -f ./assets/sqldeveloper-*.zip && echo true)
## 
## ----------------------------------------- Imports -------------------------------------------
## colors.mk: To make pipeline scripts more readable
include colors.mk
## 
## ----------------------------------------- Commands -----------------------------------------
help:		## Show this help
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

build: check	## Build either the image tagged with VERSION
	@printf "${YEL_L}Building the image${NC} ${YEL}$(CV_LOCAL_TAG)${NC}${YEL_L}...${NC}\n"
	@docker build \
		-t $(CV_LOCAL_TAG) \
		-f Dockerfile .
ifeq ($(SCAN_IMAGE), true)
	@printf "Scanning the image ${WHI}$(CV_LOCAL_TAG)${NC} for vulnerabilities...\n" 
	-@docker scan $(CV_LOCAL_TAG)
endif

push:		## Push the image to a remote container registry, needs VERSION as argument
ifndef CONTAINER_REGISTRY
	$(error Cannot push the image because 'CONTAINER_REGISTRY' is empty)
endif
ifeq ($(VERSION), local)
	$(error Please specifiy a version other than 'local' when pushing: e.g. 'make $(MAKECMDGOALS) VERSION=latest')
endif
	@printf "${YEL_L}Pushing to${NC} ${YEL}$(CV_REMOTE_TAG)${NC}${YEL_L}...${NC}\n"
	@docker tag $(CV_LOCAL_TAG) $(CV_REMOTE_TAG)
	@docker push $(CV_REMOTE_TAG)

test:		## Run a container to manually test the built image (Do not run from a pipeline)
	@docker run --rm -it \
		-p 5900:5900 \
		--name $(IMAGE_NAME) \
		$(CV_LOCAL_TAG)

build-and-push: ## Build and push the image to a remote host in one command
	$(MAKE) build && $(MAKE) push

.DEFAULT:
	@echo Unkown command $@, try make help

check:		## Look for the zip file to install sqldeveloper from
ifeq ($(CV_ZIP_EXISTS), true)
	@echo 'File to install SQLDeveloper from exists!'
else
	$(error Cannot build image! ./assets/sql-developer-*.zip does not exist)
endif
