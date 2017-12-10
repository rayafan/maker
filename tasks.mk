-include gitmodules/github.com/rayafan/maker/helpers.mk

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

DIRS := $(shell if [ -a properties.mk ] ; \
	then \
		cat properties.mk |grep _SRC= | sed "s/=.*//" | sed "s/^/$$/" ; \
	fi;)

volumes:

	$(SSHCLI) mkdir -p $(DIRS)

network.name:
ifndef NETWORK_NAME
	$(error NETWORK_NAME is undefined in project.properties)
endif
	@echo ${NETWORK_NAME}

clean:
	@rm -rf docker-compose.yml

submodule-update:
	git submodule sync --recursive
	git submodule update --remote --merge --recursive

properties.mk:
	$(shell if [ -a gitmodules/github.com/rayafan/maker/template/simple/properties.mk ] ; \
	then \
		cp gitmodules/github.com/rayafan/maker/template/simple/properties.mk properties.mk ; \
	fi;)

.gitlab-ci.yml:
	$(shell if [ -a gitmodules/github.com/rayafan/maker/template/simple/.gitlab-ci.yml ] ; \
	then \
		cp gitmodules/github.com/rayafan/maker/template/simple/.gitlab-ci.yml .gitlab-ci.yml ; \
	fi;)

ansible.yml:
	$(shell if [ -a gitmodules/github.com/rayafan/maker/template/simple/ansible.yml ] ; \
	then \
		cp gitmodules/github.com/rayafan/maker/template/simple/ansible.yml ansible.yml ; \
	fi;)

nginx/nginx.example.conf:
	@mkdir nginx
	$(shell if [ -a gitmodules/github.com/rayafan/maker/template/simple/nginx.example.conf ] ; \
	then \
		cp gitmodules/github.com/rayafan/maker/template/simple/nginx.example.conf nginx/nginx.example.conf ; \
	fi;)

du:
	@${SSHCLI} du -sh ${STACK_VOLUME_PREFIX}
	@${SSHCLI} du -sh $(DIRS)

playbook:
	ansible-playbook -i gitmodules/gitlab.com/rayafan/inventory/hosts ansible.yml

deploy: playbook up