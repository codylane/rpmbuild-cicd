# -*- mode: ruby -*-
# vi: set ft=ruby :

$LANG  = ENV.fetch('LANG', 'en_US.UTF-8')
env_args = {
  'ACTION'              => ENV.fetch('ACTION', 'default'),
  'LANG'                => $LANG,
  'LANGUAGE'            => $LANG,
  'LC_ALL'              => $LANG,
  'RPM_NAME'            => ENV.fetch('RPM_NAME', ''),
  'RPM_VERSION'         => ENV.fetch('RPM_VERSION', ''),
  'RPM_RELEASE'         => ENV.fetch('RPM_RELEASE', ''),
  'SRC_RPMS'            => ENV.fetch('SRC_RPMS', ''),
  'RPMBUILD_EXTRA_ARGS' => ENV.fetch('RPMBUILD_EXTRA_ARGS', ''),
  'QA_RPATHS'           => ENV.fetch('QA_RPATHS', ''),
  'BUILD_PACKAGES'      => ENV.fetch('BUILD_PACKAGES', ''),
}

Vagrant.configure("2") do |config|

  config.vm.define 'default' do |config|
    config.vm.box = "bento/centos-8.2"
    config.vm.hostname = "vagrant-rpmbuild-centos8"

    synced_folder_disabled = false

    # config.ssh.insert_key = false
    config.vm.box_check_update = false

    config.vm.provider "virtualbox" do |vb|
      # vb.gui = true

      vb.cpus = "2"
      vb.memory = "1024"

      # these settings will speed up DNS reslution from box -> host
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    # by default just use the default synced folder implmentation in vagrant so that
    # it mimics bind mounts in docker containers. without this mount our build scripts
    # will not be invoked.
    config.vm.synced_folder ".", "/vagrant", disabled: synced_folder_disabled, type: nil

    puts "**** Passed in ENV variables that Vagrant will use ****"
    pp env_args
    puts "*******************************************************"

    if File.exists?("vagrant-entrypoint.sh")
      config.vm.provision "shell", env: env_args, path: "vagrant-entrypoint.sh"
    end

  end

  config.vm.define 'acceptance' do |config|
    config.vm.box = "bento/centos-8.2"
    config.vm.hostname = "vagrant-rpmbuild-acceptance"

    synced_folder_disabled = false

    # config.ssh.insert_key = false
    config.vm.box_check_update = false

    config.vm.provider "virtualbox" do |vb|
      # vb.gui = true

      vb.cpus = "2"
      vb.memory = "1024"

      # these settings will speed up DNS reslution from box -> host
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    # by default just use the default synced folder implmentation in vagrant so that
    # it mimics bind mounts in docker containers. without this mount our build scripts
    # will not be invoked.
    config.vm.synced_folder ".", "/vagrant", disabled: synced_folder_disabled, type: nil

    env_args['ACTION'] = ENV.fetch('ACTION', 'test')

    puts "**** Passed in ENV variables that Vagrant will use ****"
    pp env_args
    puts "*******************************************************"

    if File.exists?("vagrant-entrypoint.sh")
      config.vm.provision "shell", env: env_args, path: "vagrant-entrypoint.sh"
    end
  end
end
