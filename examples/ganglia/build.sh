#!/usr/bin/env bash

export RPM_NAME=ganglia
export RPM_VERSION=3.7.2
export RPM_RELEASE=-33

export BUILD_PACKAGES=$(cat <<BUILD_PACKAGES_EOS
apr-devel
libart_lgpl-devel
libconfuse-devel
libmemcached-devel
libtirpc-devel
pcre-devel
rpcgen
rrdtool-devel
/usr/bin/pod2html
BUILD_PACKAGES_EOS
)

export SRC_RPMS=$(cat <<SRC_RPMS_EOS
https://kojipkgs.fedoraproject.org//packages/ganglia/3.7.2/33.el8/src/ganglia-3.7.2-33.el8.src.rpm
SRC_RPMS_EOS
)

export RPMBUILD_EXTRA_ARGS=$(cat <<RPMBUILD_EXTRA_ARGS_EOS
--define 'debug_package %{nil}' --define 'py2 1'
RPMBUILD_EXTRA_ARGS_EOS
)

[ "$#" -eq 0 ] && make rpm || eval "$@"
