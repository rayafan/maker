SHELL=/bin/bash

PROJECT_NAME=appname
PROJECT_NAMESPACE=org
NETWORK_NAME=default
MEMORY_LIMIT=4G
PUBLIC_PORT=9000
MONGO_VERSION=3
ELASTIC_VERSION=5.3.3

ifndef CI_PROJECT_NAME
CI_PROJECT_NAME=$(PROJECT_NAME)
endif

ifndef CI_COMMIT_SHA
CI_COMMIT_SHA=$(shell $(call git_sha))
endif

ifndef CI_COMMIT_REF_NAME
CI_COMMIT_REF_NAME=$(shell $(call git_current_branch))
endif

ifndef CI_PROJECT_URL
CI_PROJECT_URL=$(shell pwd)
endif

ifndef CONTAINER_RELEASE_IMAGE
CONTAINER_RELEASE_IMAGE=$(PROJECT_NAME)
endif

ifndef SEMANTIC_VERSION_TAG
SEMANTIC_VERSION_TAG=$(shell $(call git_version))
endif

ifndef SEMANTIC_VERSION_IMAGE
SEMANTIC_VERSION_IMAGE=$(CI_PROJECT_NAME):$(SEMANTIC_VERSION_TAG)
endif

ifndef DEPLOY_HOST_PORT
DEPLOY_HOST_PORT=localhost:$(PUBLIC_PORT)
endif

ifndef CI_ENVIRONMENT_SLUG
CI_ENVIRONMENT_SLUG=local
endif

ifndef DOCKER_STACK
DOCKER_STACK=$(PROJECT_NAMESPACE)_$(CI_ENVIRONMENT_SLUG)
endif

ifndef WEB_STACK
WEB_STACK=rayafan_$(CI_ENVIRONMENT_SLUG)
endif

ifndef DOCKERCLI
DOCKERCLI=docker
endif

ifndef SSHCLI
SSHCLI=eval
endif

ifndef DEPLOY_NODE_GROUP
DEPLOY_NODE_GROUP=localhost
endif

ifndef DOCKER_VOLUME_PREFIX
DOCKER_VOLUME_PREFIX=/tmp/volumes
endif

ifndef NGINX_CONFIG_DIR
NGINX_CONFIG_DIR=$(DOCKER_VOLUME_PREFIX)/rayafan_$(CI_ENVIRONMENT_SLUG)/rayafan/nginx/vhosts/
endif

ifndef STACK_VOLUME_PREFIX
STACK_VOLUME_PREFIX=$(DOCKER_VOLUME_PREFIX)/$(DOCKER_STACK)
endif

ELASTIC_VOLUME_SRC=$(STACK_VOLUME_PREFIX)/$(PROJECT_NAMESPACE)/$(PROJECT_NAME)/$(SEMANTIC_VERSION_TAG)/data/elastic/$(ELASTIC_VERSION)
MONGO_VOLUME_SRC=$(STACK_VOLUME_PREFIX)/$(PROJECT_NAMESPACE)/$(PROJECT_NAME)/$(SEMANTIC_VERSION_TAG)/data/mongo/$(MONGO_VERSION)
GRAYLOG_JOURNAL_VOLUME_SRC=$(STACK_VOLUME_PREFIX)/$(PROJECT_NAMESPACE)/$(PROJECT_NAME)/$(SEMANTIC_VERSION_TAG)/data/journal
GRAYLOG_IDENTITY_VOLUME_SRC=$(STACK_VOLUME_PREFIX)/$(PROJECT_NAMESPACE)/$(PROJECT_NAME)/$(SEMANTIC_VERSION_TAG)/graylog-identity