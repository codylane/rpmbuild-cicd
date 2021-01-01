BUILD_CONTAINER_NAME      = centos8-build
RPMBUILD_CONTAINER_NAME   = centos8-rpmbuild

VBOX_EXTENSIONS_VERSION   = 6.1.16
VBOX_EXTENSIONS_NAME      = Oracle_VM_VirtualBox_Extension_Pack-$(VBOX_EXTENSIONS_VERSION).vbox-extpack
VBOX_EXTENSIONS           = https://download.virtualbox.org/virtualbox/$(VBOX_EXTENSIONS_VERSION)/$(VBOX_EXTENSIONS_NAME)
VBOX_LICENSE_SHA256       = 33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c
VBOX_REPACKAGE_NAME       = centos8-build-virtualbox.box

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


jenkins_log:
	docker-compose logs -f jenkins


jenkins_pass:
	@docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword


jenkins_shell:
	docker-compose exec jenkins bash


jenkins_run: jenkins_build
	docker-compose up -d jenkins
	@echo ">>>> Attempting to populate jenkins credentials.xml with your SSH key <<<<<"
	@docker-compose exec -u root -T jenkins wait-for-api update_jenkins_credentials


rpm: build
	docker-compose run $(BUILD_CONTAINER_NAME) /entrypoint.sh


run: build
	docker-compose run $(BUILD_CONTAINER_NAME)


shell: build
	docker-compose run $(BUILD_CONTAINER_NAME) /bin/bash -l


test_build:
	docker-compose build $(BUILD_CONTAINER_NAME)-acceptance


test: test_build
	docker-compose run $(BUILD_CONTAINER_NAME)-acceptance /acceptance/runner.sh rake spec:$${RPM_NAME}


test_shell:
	docker-compose run $(BUILD_CONTAINER_NAME)-acceptance /acceptance/runner.sh bash -l


vagrant_install_plugins:
	# due to a bug upstream with vagrant versions 2.11 - 2.13 you'll need to
	# stick with vagrant-vbguest 0.26.0
	vagrant plugin install vagrant-vbguest --plugin-version 0.26.0


vbox_download_centos8:
	vagrant box add bento/centos-8.2 --provider virtualbox


vbox_download_extensions:
	curl -L $(VBOX_EXTENSIONS) -o $(VBOX_EXTENSIONS_NAME)
	VBoxManage extpack install --replace --accept-license=$(VBOX_LICENSE_SHA256) $(VBOX_EXTENSIONS_NAME)


vbox: vbox_download_extensions vbox_download_centos8 vagrant_install_plugins


vbox_build: vbox_clean vbox_run vbox_stop vbox_snapshot


vbox_run:
	ACTION=$(ACTION) vagrant up --provision default
	vagrant ssh -c 'sync'


vbox_clean:
	vagrant destroy -f default


vbox_rpm:
	ACTION=rpm vagrant up --provision default


vbox_reload: vbox_restore
	vagrant provision default


vbox_restore:
	vagrant snapshot restore default base


vbox_shell:
	vagrant ssh default


vbox_snapshot:
	vagrant snapshot save -f default base


vbox_stop:
	vagrant halt -f default


vbox_acceptance_shell:
	vagrant ssh acceptance


vbox_repackage: vbox_stop
	vagrant package --output $(VBOX_REPACKAGE_NAME) default


vbox_test_clean:
	vagrant destroy -f acceptance


vbox_test:
	ACTION=acceptance vagrant up --provision acceptance
