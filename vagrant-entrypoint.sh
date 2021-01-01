#!/usr/bin/env bash

CMD="${BASH_SOURCE[0]}"
BIN_DIR="${CMD%/*}"
cd "${BIN_DIR}"

VAGRANT_VOLUME_DIR=/vagrant


usage()
{
  cat <<- EOS
Usage: ${CMD} [endpoint]

[endpoints]
  default -> Boots the system and builds a base development box.
  rpm     -> Boots the built box and attempts to build the RPM.

EOS

  exit 0

}


build_rpm()
{
  echo "***************** Building the RPM *********************"
  cd /
  ./entrypoint.sh
  echo "********************************************************"
  cd - >>/dev/null 2>&1
}


install_build_packages() {
  dnf clean expire-cache || true
  dnf --enablerepo PowerTools -y install ${BUILD_PACKAGES}
}


install_default_packages()
{
  dnf install -y \
    epel-release \
    glibc-locale-source

  dnf --enablerepo PowerTools -y install          \
    ${BUILD_PACKAGES}                             \
    @development                                  \
    ack                                           \
    bzip2-devel                                   \
    ctags                                         \
    expat-devel                                   \
    gdbm-devel                                    \
    git                                           \
    glibc-langpack-tr                             \
    libdb-devel                                   \
    libffi-devel                                  \
    libpcap-devel                                 \
    libsqlite3x-devel                             \
    libsq3-devel                                  \
    neovim                                        \
    ncurses-devel                                 \
    openssl-devel                                 \
    python2-devel                                 \
    python38-devel                                \
    rpm-build                                     \
    readline-devel                                \
    rpmdevtools                                   \
    rsync                                         \
    ruby-devel                                    \
    sqlite-devel                                  \
    systemtap-sdt-devel                           \
    tk-devel                                      \
    xz-devel                                      \
    zlib-devel
}

install_test_packages()
{
  rpm -q epel-release || dnf install -y epel-release

  dnf clean expire-cache

  local install_pkgs=

  rpm -q curl || install_pkgs="${install_pkgs} curl"
  rpm -q git  || install_pkgs="${install_pkgs} git"
  rpm -q gcc  || install_pkgs="${install_pkgs} gcc"
  rpm -q make || install_pkgs="${install_pkgs} make"
  rpm -q neovim || install_pkgs="${install_pkgs} neovim"

  [ -z "${install_pkgs}" ] || dnf install -y "${install_pkgs}"

  rpm -q acceptance-ruby || dnf localinstall -y ${VAGRANT_VOLUME_DIR}/rpmbuild/RPMS/x86_64/acceptance-ruby-2.5.8-1.el8.x86_64.rpm

  . /etc/profile.d/acceptance-rubies.sh

  ${VAGRANT_VOLUME_DIR}/acceptance/runner.sh rake spec:${RPM_NAME}
}

setup_symlinks()
{
  cd /
  ln -sf ${VAGRANT_VOLUME_DIR}/entrypoint.d
  ln -sf ${VAGRANT_VOLUME_DIR}/entrypoint.sh
  ln -sf ${VAGRANT_VOLUME_DIR}/examples
  ln -sf ${VAGRANT_VOLUME_DIR}/rpmbuild
  ln -sf ${VAGRANT_VOLUME_DIR}/acceptance
  ln -sf ${VAGRANT_VOLUME_DIR}/profile.d/acceptance-rubies.sh /etc/profile.d/
  cd - >>/dev/null 2>&1
}

setup_symlinks

ACTION="${ACTION:-${1:-default}}"

echo ">>> ACTION: '${ACTION}' <<<"

case "${ACTION}" in

  default)
    install_default_packages
  ;;

  rpm)
    install_default_packages
    build_rpm
  ;;

  acceptance)
    install_test_packages
  ;;

  *)
    usage
  ;;

esac
