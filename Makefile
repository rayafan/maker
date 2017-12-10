#!make
SHELL=/bin/bash

-include gitmodules/github.com/rayafan/maker/tasks.mk
-include properties.mk

.DEFAULT_GOAL := build

export $(shell if [ -a properties.mk ] ; \
               then \
                    sed 's/=.*//' properties.mk | awk '!/ /' | awk '!/endif/' ; \
               fi;)

.PHONY: docker-compose.yml volumes maker build du template

build: pull docker-compose.yml
	docker build -t ${SEMANTIC_VERSION_IMAGE} .

push: build
	docker push ${SEMANTIC_VERSION_IMAGE}

release: docker-compose.yml
	docker pull ${SEMANTIC_VERSION_IMAGE}
	docker tag ${SEMANTIC_VERSION_IMAGE} ${CONTAINER_RELEASE_IMAGE}
	docker push ${CONTAINER_RELEASE_IMAGE}

up: volumes build
	${SSHCLI} mkdir -p ${DOCKER_STACK}/${CI_PROJECT_NAME}
	cat ./docker-compose.yml | ${SSHCLI} "cat > ${DOCKER_STACK}/${CI_PROJECT_NAME}/docker-compose.yml"
	${DOCKERCLI} stack up --with-registry-auth -c ${DOCKER_STACK}/${CI_PROJECT_NAME}/docker-compose.yml ${DOCKER_STACK}
	${DOCKERCLI} network ls
	${DOCKERCLI} stack ls
	${DOCKERCLI} stack services ${DOCKER_STACK}

gitmodules-maker:
	git submodule add --force https://github.com/rayafan/maker.git gitmodules/github.com/rayafan/maker

gitmodules-inventory:
	git submodule add --force git@gitlab.com:rayafan/inventory.git gitmodules/gitlab.com/rayafan/inventory

pull:
	git submodule init
	git submodule sync --recursive
	git submodule update --remote --merge --recursive

deinit:
	git submodule  deinit -f .
	git rm -f gitmodules/github.com/rayafan/maker
	git rm -f gitmodules/gitlab.com/rayafan/inventory

init: gitmodules-maker gitmodules-inventory pull

template: properties.mk .gitlab-ci.yml ansible.yml docker-compose.test.yml docker-compose.tpl.yml nginx.example.conf



