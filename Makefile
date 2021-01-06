CONTAINER_PREFIX          = centos8
BUILD_CONTAINER_NAME      = $(CONTAINER_PREFIX)-build
RPMBUILD_CONTAINER_NAME   = $(CONTAINER_PREFIX)-rpmbuild
ACCEPTANCE_CONTAINER_NAME = $(CONTAINER_PREFIX)-acceptance

# docker
.PHONY: build
.PHONY: clean
.PHONY: destroy
.PHONY: rpm
.PHONY: run
.PHONY: shell
.PHONY: test
.PHONY: test_build
.PHONY: test_shell

# jenkins
.PHONY: jenkins_build
.PHONY: jenkins_clean
.PHONY: jenkins_destroy
.PHONY: jenkins_destroy_volume
.PHONY: jenkins_log
.PHONY: jenkins_pass
.PHONY: jenkins_shell
.PHONY: jenkins_run

# vbox + vagrant
.PHONY: vagrant_install_plugins

.PHONY: vbox
.PHONY: vbox_acceptance_shell
.PHONY: vbox_clean
.PHONY: vbox_download_extensions
.PHONY: vbox_download_centos8
.PHONY: vbox_repackage
.PHONY: vbox_snapshot
.PHONY: vbox_stop
.PHONY: vbox_test
.PHONY: vbox_test_clean

all: build


build:
	docker-compose build $(BUILD_CONTAINER_NAME)
	docker-compose build $(RPMBUILD_CONTAINER_NAME)


clean:
	rm -rf rpmbuild/BUILD/*
	rm -rf rpm-tnsping/
	rm -f *.vbox-extpack
	find rpmbuild/ -name '*.rpm' -type f -delete
	find rpmbuild/ -name '*.tar.gz' -type f -delete


destroy:
	docker-compose rm -fsv
	vagrant destroy -f


jenkins_build:
	[ -f ${HOME}/.ssh/id_rsa ] && cp ${HOME}/.ssh/id_rsa gitserver_ssh_key
	docker-compose build jenkins


jenkins_clean: jenkins_destroy
	@rm -rf tmp/empty
	@docker-compose down                     \
		--rmi all                            \
		--volumes                            \
		--remove-orphans


jenkins_destroy:
	docker-compose rm -fsv jenkins || true


jenkins_destroy_volume: jenkins_destroy
	docker volume rm -f $(shell docker volume ls -q -f name=rpmbuild-cicd) >>/dev/null 2>&1 || true


jenkins_job:
	docker-compose exec \
		-T          \
		jenkins     \
		jenkins-cli \
			build   \
			testing \
			-v      \
			-s      \
			-p RPM_NAME=ganglia  \
			-p RPM_VERSION=3.7.2 \
			-p RPM_RELEASE=-33   \
			-p SRC_RPMS='https://kojipkgs.fedoraproject.org//packages/ganglia/3.7.2/33.el8/src/ganglia-3.7.2-33.el8.src.rpm'

jenkins_log:
	docker-compose logs -f jenkins


jenkins_pass:
	@docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword


jenkins_shell:
	docker-compose exec jenkins bash


jenkins_run: jenkins_build
	docker-compose up -d jenkins
	@docker-compose exec -u root jenkins wait-for-api

rpm: build
	docker-compose run $(RPMBUILD_CONTAINER_NAME) /entrypoint.sh


run: build
	docker-compose run $(RPMBUILD_CONTAINER_NAME)


shell: build
	docker-compose run $(RPMBUILD_CONTAINER_NAME) /bin/bash -l


test_build:
	docker-compose build $(ACCEPTANCE_CONTAINER_NAME)


test: test_build
	docker-compose run $(ACCEPTANCE_CONTAINER_NAME) /acceptance/runner.sh rake spec:$${RPM_NAME}


test_shell:
	docker-compose run $(ACCEPTANCE_CONTAINER_NAME) /acceptance/runner.sh bash -l
