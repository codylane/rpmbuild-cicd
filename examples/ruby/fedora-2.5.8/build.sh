#!/usr/bin/env bash

export RPM_NAME=ruby
export RPM_VERSION=2.5.8
export RPM_RELEASE=-107

export BUILD_PACKAGES=$(cat <<BUILD_PACKAGES_EOS
  cmake
  gmp-devel
  libyaml-devel
  multilib-rpm-config
BUILD_PACKAGES_EOS
)

export SRC_RPMS=$(cat <<SRC_RPMS_EOS
https://kojipkgs.fedoraproject.org/packages/ruby/2.5.8/107.module_f31+10493+fc56f369/src/ruby-2.5.8-107.module_f31+10493+fc56f369.src.rpm
SRC_RPMS_EOS
)

export PATCH_SPEC=ruby.spec.patch

cat > rpmbuild/SPECS/ruby.spec.patch <<- 'SPEC_FILE_PATCH'
--- ruby.spec.orig	2021-01-06 17:22:20.334282000 +0000
+++ ruby.spec	2021-01-06 17:22:46.156966000 +0000
@@ -661,6 +661,7 @@
 cp %{SOURCE1} %{buildroot}%{rubygems_dir}/rubygems/defaults

 # Move gems root into common direcotry, out of Ruby directory structure.
+([ -d %{buildroot}%{ruby_libdir}/gems ] && [ ! -d %{buildroot}%{gem_dir} ]) && mv %{buildroot}%{ruby_libdir}/gems %{buildroot}%{gem_dir}
-mv %{buildroot}%{ruby_libdir}/gems %{buildroot}%{gem_dir}

 # Create folders for gem binary extensions.
SPEC_FILE_PATCH

export RPMBUILD_EXTRA_ARGS=$(cat <<RPMBUILD_EXTRA_ARGS_EOS
RPMBUILD_EXTRA_ARGS_EOS
)

[ "$#" -eq 0 ] && make rpm || eval "$@"
