include maker/helpers.mk

version:
	@echo `$(call git_version)`

revision:
	@echo `$(call git_revision)`

environment:
	@env

docker-compose.yml:
	envtpl < docker-compose.tpl.yml > docker-compose.yml

ls:
	$(DOCKERCLI) stack services $(DOCKER_STACK)

rm:
	$(DOCKERCLI) stack rm $(DOCKER_STACK)

ps:
	$(DOCKERCLI) stack ps $(DOCKER_STACK)

DIRS := $(shell cat properties.mk |grep _SRC= | sed "s/=.*//" | sed "s/^/$$/")

volumes:

	$(SSHCLI) mkdir -p $(DIRS)

network.name:
ifndef NETWORK_NAME
	$(error NETWORK_NAME is undefined in project.properties)
endif
	@echo ${NETWORK_NAME}

clean:
	@rm -rf docker-compose.yml

maker-upgrade:
	git -C maker pull
