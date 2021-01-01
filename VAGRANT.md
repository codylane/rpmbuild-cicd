How to Vagrant
==============

* First you need to [download vagrant](https://www.vagrantup.com/downloads.html)
  * **NOTE:** This documentation was created using vagrant version `2.2.14`

* Next, you need to decide which hypervisor to use. The easiest one to
  use to start out with is [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

* The `Vagrantfile` contained in this repo supports VirtualBox
  out of the box. If you prefer to use something else you can
  consult the vagrant documentation for further details. Vagrant
  supports a lot of different types these days.


## VirtualBox

* The `Vagrantfile` is known to work with and was tested with the following
  version of virtual box.

  ```
  $ VBoxManage --version
  6.1.16r14096
  ```

  ```
  $ vagrant --version
  Vagrant 2.2.14
  ```

* Next, you can run this command to automate the rest of the setup.

  **NOTE:** You should only need to do this once.

  ```
  make vbox
  ```

### Running Vagrant in VirtualBox

#### **Prepping for Build**
  * This step will download the CentOS 8 box from the Internet
  * Fire up the box and install the build dependencies needed
    to build the RPM.
  * Shutdown the machine
  * Snapshots the machine as `base` to save you time so that
    you can revert at anytime to hopefully help save you time.

    ```
    make build
    ```

  * **Advanced Tip**

    * You can also repackage this vagrant environment at anytime and create a new image from the current state.

      ```
      make vbox_repackage
      ```
    * This will shut down the box, and create a single filename that
      contains your new image. You can add this new image to your vagrant
      box store using the `vagrant box add` command.

#### **Building the RPM**
  * Create the vagrant box
  * Provision the vagrant box to a default base level
  * Provision and build your custom RPM

  ```
  make vbox_rpm
  ```


#### **Running the acceptance tests**
  * In order for this to work, you first need to build `acceptance-ruby`

  * **NOTE:** If there are no changes to `acceptance-ruby` and it
    already exists in `rpmbuild/RPMS/x86_64/acceptance-ruby-2.5.8-1.el8.x86_64.rpm`
    then, you do not need to build it each time. You'll only need to
    rebuild acceptance-ruby as needed or if you make changes.

  ```
  examples/ruby/2.5.8/build.sh make vbox_rpm
  ```

  * Once you have `acceptance-ruby` built, you can login to the shell of
    the vagrant box.
  * **NOTE: Acceptance tests should be run as the root user**

    ```
    vagrant ssh acceptance
    sudo su -
    cd /vagrant/acceptance
    rake spec
    ```

  * Now the same example as above but without logging into the Vagrant box.

    ```
    examples/ruby/2.5.8/build.sh make vbox_test
    ```
