Jenkins
=======

This directory contains some of the scripts used to configure and
orchestrate the setup of a small Jenkins environment that you can use
for local testing.

# Disclaimer

* This was intended to be run on your local development workstation and
  maybe a bit too loose to use in production. Evaluate the security
  requirements for your environment before deploying or using this code
  outside of your workstation.

# Helpful Links

For those that would like to know more how this was setup and how you
might tinker with some of the settings

* https://github.com/jenkinsci/docker/blob/master/README.md
* https://docs.docker.com/compose/compose-file/compose-file-v3/
* https://docs.docker.com/storage/volumes/
* https://devopscube.com/run-docker-in-docker/


# Design and use overview

This docker-compose service for jenkins will automate the following
steps for you automatically:

* **NOTE:** This pipeline is using some very advanced docker features
  like DID (Docker in Docker) to provide you with a seamless experience.

* It will fire up and configure the latest Jenkins
* It will create a copy of your `~/.ssh/id_rsa` ssh key and use it as a
  secret credential that is securely passed into the jenkins container,
  when the container is built or running.
* It will automatically configure the SSH known_hosts file so that you
  can clone bitbucket repos without needing to accept the known_hosts
  key.
* When jenkins is running you can open your browser to `http://localhost:8081`

# What to do when you login to jenkins for the first time

* Jenkins will prompt you for the admin password which is automatically
  created and random each time the container is rebuilt from scratch.
* Jenkins will tell you where you can find this password.
* You will need this password to login to your jenkins instance anytime you want to
  access the jenkins webserver.

   * **NOTE:** You can find out how to get the passwords if you misplaced further
     below in this README.

* After entering your admin password you might see a screen that says
  "Getting Started". Unless you want customize further you can just
  skip the next two screens.

# How to build the Jenkins container

```
make jenkins_build
```

# How to destroy the Jenkins container

* **NOTE:** This just removes the container but leaves the named volume intact

```
make jenkins_destroy
```

# How to wipe Jenkins environment

* **NOTE:** This removes the image, named volume, network, container.

```
make jenkins_clean
```

# How to view the jenkins logs

```
make jenkins_log
```

# How to open an interactive terminal session to the Jenkins container

```
make jenkins_shell
```

# How to run the jenkins container

```
make jenkins_run
```

# Known Issues

* This section lists some of the known issues and workarounds that you
  might encounter when using the Jenkins container.

## I don't want to rebuild the container from scratch but can I wipe the volume and start over without waiting forever?

* Indeed, you can do that, just run this. This will stop the container and whack the volume removing all the persisted data from jenkins.

```
make jenkins_destroy_volume
```

## Jenkins is persisting my data but I want to wipe the volume and start over

* The docker container uses a named volume to persist the data incase
  the container is stopped or restarted. If the container errors out
  during the build, the volume will be in a bad state, and you'll need to
  manually remove it like so.

  ```
  # check to see if any docker container processes are running
  docker ps -a

  # you will be looking for something like this
  2a8c4359bfd3   rpmbuild-cicd "/entrypoint.sh" 17 minutes ago   Exited (0) 9 minutes ago

  # you need to remove this container and it's volume
  docker rm -vf a28

  # now, ensure the volumes are not dangling
  docker volume prune -f
  ```

## Where can I find the password to login to jenkins

* There are multiple ways to accomplish this.

* This will spit out the jenkins admin password to stdout on your terminal.

```
make jenkins_pass
```

* This will require you to login and manually grab the password.

```
make jenkins_shell
cat /var/jenkins_home/secrets/initialAdminPassword
```

* The password can also be obtained from the jenkins log

```
make_jenkins_log

# or

docker-compose logs -f jenkins
```
