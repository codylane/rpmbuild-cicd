#!/usr/bin/env bash

export RPM_NAME=neovim
export RPM_VERSION=0.4.4
export RPM_RELEASE=-1

export BUILD_PACKAGES=$(cat <<BUILD_PACKAGES_EOS
cmake
compat-lua-mpack
desktop-file-utils
fdupes
gperf
libtermkey-devel
libuv-devel
lua-luv-devel
libvterm-devel
lua5.1-luv-devel
lua5.1-lpeg
luajit-devel
msgpack-devel
unibilium-devel
BUILD_PACKAGES_EOS
)

export PATCH_SPEC=neovim.spec.patch
cat > rpmbuild/SPECS/neovim.spec.patch << 'SPEC_PATCH'
--- neovim.spec	2020-08-05 13:49:51.000000000 +0000
+++ neovim-centos.spec	2021-02-18 18:31:51.409160000 +0000
@@ -36,7 +36,6 @@
 # luajit implements version 5.1 of the lua language spec, so it needs the
 # compat versions of libs.
 BuildRequires:  luajit-devel
-BuildRequires:  compat-lua-lpeg
 BuildRequires:  compat-lua-mpack
 BuildRequires:  lua5.1-luv-devel
 Requires:       lua5.1-luv
SPEC_PATCH

export SRC_RPMS=$(cat <<SRC_RPMS_EOS
https://kojipkgs.fedoraproject.org/packages/neovim/0.4.4/1.fc32/src/neovim-0.4.4-1.fc32.src.rpm
SRC_RPMS_EOS
)

export RPMBUILD_EXTRA_ARGS=$(cat <<RPMBUILD_EXTRA_ARGS_EOS
RPMBUILD_EXTRA_ARGS_EOS
)

[ "$#" -eq 0 ] && make rpm || eval "$@"
