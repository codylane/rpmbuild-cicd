#!/usr/bin/env bash

export RPM_NAME=neovim
export RPM_VERSION=0.4.4
export RPM_RELEASE=1

export BUILD_PACKAGES=$(cat <<BUILD_PACKAGES_EOS
cmake
compat-lua-mpack
desktop-file-utils
fdupes
gperf
libtermkey-devel
libuv-devel
lua-devel
lua-luv-devel
libvterm-devel
lua5.1-luv-devel
lua5.1-lpeg
lua-lpeg
lua-mpack
luajit-devel
msgpack-devel
unibilium-devel
BUILD_PACKAGES_EOS
)

export SRC_RPMS=$(cat <<SRC_RPMS_EOS
https://kojipkgs.fedoraproject.org/packages/neovim/0.4.4/1.fc32/src/neovim-0.4.4-1.fc32.src.rpm
SRC_RPMS_EOS
)

export RPMBUILD_EXTRA_ARGS=$(cat <<RPMBUILD_EXTRA_ARGS_EOS
RPMBUILD_EXTRA_ARGS_EOS
)

[ "$#" -eq 0 ] && make rpm || eval "$@"
