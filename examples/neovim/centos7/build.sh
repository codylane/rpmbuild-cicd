#!/usr/bin/env bash

export RPM_NAME=neovim
export RPM_VERSION=0.4.4
export RPM_RELEASE=1

export BUILD_PACKAGES=$(cat <<BUILD_PACKAGES_EOS
curl
BUILD_PACKAGES_EOS
)

export SRC_RPMS=$(cat <<SRC_RPMS_EOS
SRC_RPMS_EOS
)

export RPMBUILD_EXTRA_ARGS=$(cat <<RPMBUILD_EXTRA_ARGS_EOS
RPMBUILD_EXTRA_ARGS_EOS
)

cp rpmbuild/neovim.spec rpmbuild/SPECS/

[ "$#" -eq 0 ] && make rpm || eval "$@"
