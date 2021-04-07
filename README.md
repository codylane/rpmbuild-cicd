RPMBUILD CICD
=============

# Table of Contents
- [Requirements](#requirements)
- [Usage](#usage)
   - [Environment Variables](#environment-variables)
   - [When Building the docker container](#when-building-the-docker-container)
      - [BUILD_PACKAGES](#build_packages)
   -  [When Running the docker container](#when-running-the-docker-container)
       -  [RPM_NAME](#rpm_name)
       -  [RPM_VERSION](#rpm_version)
       -  [RPM_RELEASE](#rpm_release)
       -  [SRC_RPMS](#src_rpms)
       -  [RPM_PACKAGE_NAME](#rpm_package_name)
       -  [RPMBUILD_EXTRA_ARGS](#rpmbuild_extra_args)
       -  [RPMBUILD_SPEC_FILE](#rpmbuild_spec_file)
    - [Building the docker container for the first time](#building-the-docker-container-for-the-first-time)
    - [Run the container](#run-the-container)
    - [Building the RPM inside the container](#building-the-RPM-inside-the-container)
    - [Build the RPM without an interactive shell](#build-the-rpm-without-an-interactive-shell)
    - [Testing the built RPMs](#testing-the-built-rpms)
- [Build Pipeline Documentation](#build-pipeline-documentation)
  - [Build Pipeline Commands](#build-pipeline-commands)

# Usage

* Please ensure that `docker`, `docker-compose` and `make` are installed on your workstation.
* https://www.docker.com/get-started
* https://get.docker.com/
* https://docs.docker.com/compose/install/

* **NOTE:** Due to upstream changes in CentOS 8, please ensure you are using at least CentOS >= `8.3.2011`.
            If the automation pipeline fails when trying to install packages via the `PowerTools` repo,
            ensure that CentOS has not changed that too `powertools` or visa versa.
            https://wiki.centos.org/action/show/Manuals/ReleaseNotes/CentOS8.2011?action=show&redirect=Manuals%2FReleaseNotes%2FCentOSLinux8

## Environment variables

### When Building the docker container

* These argument variables can be passed to your container builds

#### `BUILD_PACKAGES`

* **Description:** Additional build packages can be passed to the docker build during this variable.
  * **If specifying multiple packages:** Be sure to quote each line properly.
* **Required:** **Y**
* **Default Value:**
* **Usage:** Used inside [docker-compose.yml](docker-compose.yml) and [Dockerfile.centos8-build](Dockerfile.centos8-build)
* **Examples:**
* ```
  ---
  # In this example we pass the following extra arguments to the running
  # container during the docker build step

  services:
    centos8:
      build:
        context: '.'
        dockerfile: Dockerfile.centos8-build

        args:
          BUILD_PACKAGES: >-
            apr-devel
            libart_lgpl-devel
            libconfuse-devel
            libmemcached-devel
            libtirpc-devel
            pcre-devel
            rpcgen
            rrdtool-devel
            /usr/bin/pod2html
  ```
  Another example is using environment variables from a script

  See [examples/ganglia/build.sh](examples/ganglia/build.sh) in this repo.

  ```
  . examples/ganglia/build.sh
  ```
#### `LANG`

* **Description:** The locale language
* **Required:** **Y**
* **Default Value:** `en_US.UTF-8`
* **Usage:** Used during docker build and running the container.


### When Running the docker container

* These environment variables can be passed to your container builds or
  running container.

#### `LANG`

* **Description:** The locale language
* **Required:** **Y**
* **Default Value:** `en_US.UTF-8`
* **Usage:** Used inside [docker-compose.yml](docker-compose.yml) and [Dockerfile.centos8-build](Dockerfile.centos8-build)

#### `RPM_NAME`

* **Description:** The short name of the RPM
* **Required:** **Y**
* **Default Value:**
* **Usage:** Used during acceptance testing, building and running the container.
* **Example:** `ganglia`

#### `RPM_VERSION`

* **Description:** The **major**.**minor**.**patch** of the RPM in this format.
* **Required:** **Y**
* **Default Value:**
* **Usage:** Used during acceptance testing, building and running the container.
* **Example:** `3.7.2`

#### `RPM_RELEASE`

* **Description:** The build number.
* **Required:** **Y**
* **Default Value:** - Defaults to current HEAD sha.
* **Usage:** Used during acceptance testing, building the RPM and running the container.
* **Examples:**
  * `-33`
  * `abc12de`

#### `SRC_RPMS`
* **Description:** A list of **src** of RPMS to use as a template.
  * **If specificying a URL:** Be sure to quote each URL line properly.
* **Required:** **N**
* **Default Value:**
* **Usage:** Used during building the container, RPM and running the container.
* **Examples:**
* This is a [docker-compose.yml](docker-compose.yml) config setting.
  ```
  ---
  # In this examle we install two different source RPMS during our RPM build.
  # NOTE: this happens before we attempt to build a new RPM

  services:
    centos8:
      environment:
        SRC_RPMS: >-
          "https://kojipkgs.fedoraproject.org//packages/ganglia/3.7.2/33.el8/src/ganglia-3.7.2-33.el8.src.rpm"
          "https://kojipkgs.fedoraproject.org/packages/python38/3.8.6/1.fc31/src/python38-3.8.6-1.fc31.src.rpm"
  ```
 Another example is using environment variables from a script

  See [examples/ganglia/build.sh](examples/ganglia/build.sh) in this repo.

  ```
  . examples/ganglia/build.sh
  ```

#### `RPMBUILD_SPEC_FILE`

* **Description:** - Changes name of the SPEC file to use when building the RPM.
  * **If specificying a URL:** Be sure to quote each URL line properly.
* **Required:** **N**
* **Default Value:** `${RPM_NAME}.spec`
* **Usage:** Used when running the container and building the RPM.

#### `RPM_PACKAGE_NAME`

* **Description:** Allows you to customize the name of the full RPM package name.
* **Required:** **N**
* **Default Value:** `"${RPM_NAME}-${RPM_VERSION}-${RPM_RELEASE}${RPMBUILD_DIST}`
* **Usage: not currently in use**

#### `RPMBUILD_EXTRA_ARGS`

* **Description:** Additional arguments that are passed to the command
  line during the RPM build.
  * **If specificying multiple arguments:** Be sure to quote each line properly.
* **Required:** **N**
* **Default Value:**
* **Usage:** Used by RPM build when running the container.
* ```
  ---
  # In this example we pass the following extra arguments to the running
  # container during `rpmbuild` via the compose file

  services:
    centos8:
      build:
        context: '.'
        dockerfile: Dockerfile.centos8-build
        args:
          RPMBUILD_EXTRA_ARGS: >-
            "--define 'debug_package %{nil}'"
  ```

  Another example is using environment variables from a script

  See [examples/ganglia/build.sh](examples/ganglia/build.sh) in this repo.

  ```
  . examples/ganglia/build.sh
  make
  ```



## Building the RPM inside the container

* After the container is running you'll be dropped into `/` of the contaienr.

* From here there is a script called `./entrypoint.sh` and it's goal is to execute anything in ascii sorted order inside `/entrypoint.d`.

* **NOTE**: You shouldn't need to modify `entrypoint.sh`.

* Further customization or scripting can be done inside or outside of the container in the `entrypoint.d` directory.

* **REMINDER**: Since `/rpmbuild` and `/entrypoint.d` are bind mounts all changes will persist outside of the docker container.

* **REMINDER**: When you exit the container's interactive shell, the container is automatically removed. So the next time you run `make run` you are in a fresh environment.


# Testing the built RPMs

**TODO we need to fill in this section**

* This step should be peformed after you have sucessfully generated a RPM artifact.
* The RPM should be contained inside the directory `rpmbuild/RPMS/x86_64/`

* To test the RPM install

```
make test
```

# Build Pipeline Documentation

* This section provides some examples of how to use the RPM build pipeline
  either in Vagrant or Docker.
* The build pipeline commands are intended to be simliar in nature.


## Standard commands used for this pipeline

* The schema for pipeline `make` commands is `$hypervisor_$command`
* The **default** hypervisor does not have `make` commands that start with `$hypervisor_`.
* The **default** hypervisor is `Docker`
* If using the default hypervisr (Docker) in this case, then the `make` comand for
  **build** is just `build`

* The following table lists the standard pipeline RPM build commands
  that are for use with `make`.

| Make Command  | Description                                                                      |
| ------------- | -------------------------------------------------------------------------------- |
| **build**     | Builds the container or box to a base build state.                               |
| **clean**     | Cleans and removes the container or box, thus destroying the build pipeline.     |
| **run**       | Fire up the container or box for interaction.                                    |
| **rpm**       | Fire up the container or box and invoke the entrypoint scripts to build the RPM  |
| **test**      | Fire up the container or box and run the acceptance tests based of the $RPM_NAME |
| **shell**     | Fire up the container or box and pop you into a shell.                           |

## Build Pipeline Commands

### Building the docker container for the first time - Docker

* Building the docker container for the first time is will take a long time.
* The goal of the build is to minimize compile time dependencies needed to
  create new software. The tradeoff is slow build == faster RPM builds.
* To build the docker container

```
make build
```

### Run the container - Docker

* This step will build the container if not already built or use the cached built image.
* This step will bind mount the `rpmbuild` directory inside the container to `/rpmbuild`
* This will bind mount the `entrypoint.d` directory inside the container to `/entrypoint.d`.
* The container will be launched in `interactive` mode with the default shell being `/bin/bash`.

```
make run
```

### Build the RPM without an interactive shell - Docker

* This step assumes you have already built the container.
* This step will launch the container and execute the `entrypoint.sh` script and run through
  the entire RPM build process and exit and remove the container when finished.
* If this step is successfull the RPMs can be found in the `rpmbuild/RPMS` and `rpmbuild/SRPMS` directory.

```
make rpm
```
