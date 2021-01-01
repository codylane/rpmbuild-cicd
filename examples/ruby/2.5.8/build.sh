#!/usr/bin/env bash

spec_file()
{

cat <<- 'SPEC_FILE_EOS'
%define root_dir        /opt/ruby
%define ruby_major      2
%define ruby_minor      5
%define ruby_patch      8
%define ruby_build      0
%define ruby_release    %{ruby_major}.%{ruby_minor}.%{ruby_patch}
%define pkg_release     1

%define ruby_build_url  https://github.com/rbenv/ruby-build/archive/v20201210.tar.gz

%if %{ruby_build}
%define install_version %{version}-%{ruby_build}
%else
%define install_version %{version}
%endif

Name:           acceptance-ruby
Version:        %{ruby_release}
Release:        %{pkg_release}%{?dist}
Summary:        Contains ruby-%{install_version}

Group:          Development/Languages
License:        MIT
URL:            http://ftp.ruby-lang.org/pub/ruby/ruby-%{install_version}.tar.gz
Source0:        %{name}-%{install_version}.tar.gz

Provides: %{name} = %{ruby_release}

BuildRequires: bzip2
BuildRequires: git
BuildRequires: gcc
BuildRequires: gdbm-devel
BuildRequires: libffi-devel
BuildRequires: ncurses-devel
BuildRequires: openssl-devel
BuildRequires: readline-devel
BuildRequires: yaml-cpp-devel
BuildRequires: zlib-devel

%description
Ruby is the interpreted scripting language for quick and easy
object-oriented programming.  It has many features to process text
files and to do system management tasks (as in Perl).  It is simple,
straight-forward, and extensible.

%prep
curl -L %{ruby_build_url} -o ruby-build.tar.gz
tar zxf ruby-build.tar.gz
cd ruby-build-20201210
PREFIX=/usr/local ./install.sh
cd -

/usr/local/bin/ruby-build %{ruby_release} %{root_dir}/%{ruby_release}

# install some gems into the new ruby
%{root_dir}/%{ruby_release}/bin/gem install \
  bundler    \
  pry        \
  neovim     \
  rake       \
  serverspec

# create a source tarball of this new ruby + gems
tar czf %{_sourcedir}/%{name}-%{install_version}.tar.gz %{root_dir}/%{ruby_release}

%install
install -d -m 755 %{buildroot}/%{root_dir}/
rsync -ma %{root_dir}/%{ruby_release} %{buildroot}/%{root_dir}/

%files
%defattr(-,root,root,-)
%{root_dir}/%{ruby_release}/bin
%{root_dir}/%{ruby_release}/include
%{root_dir}/%{ruby_release}/lib
%doc %{root_dir}/%{ruby_release}/share
%attr(0755,root,root) %dir %{root_dir}/%{ruby_release}

SPEC_FILE_EOS

}

# place our custom spec file in the right place
# for rpmbuild to find it
spec_file > rpmbuild/SPECS/acceptance-ruby.spec

# global variables that are used for the rpmbuild process
export RPM_NAME=acceptance-ruby
export RPM_VERSION=2.5.8
export RPM_RELEASE=-1

export ACCEPTANCE_BUILD_PACKAGES=$(cat <<ACCEPTANCE_BUILD_PACKAGES_EOS
ACCEPTANCE_BUILD_PACKAGES_EOS
)

export BUILD_PACKAGES=$(cat <<BUILD_PACKAGES_EOS
curl
git
gcc
make
bzip2
openssl-devel
libyaml
libffi-devel
readline-devel
zlib-devel
gdbm-devel
ncurses-devel
/usr/bin/cmake
gmp-devel
multilib-rpm-config
yaml-cpp-devel
BUILD_PACKAGES_EOS
)

export SRC_RPMS=$(cat <<SRC_RPMS_EOS
SRC_RPMS_EOS
)

export RPMBUILD_EXTRA_ARGS=$(cat <<RPMBUILD_EXTRA_ARGS_EOS
--undefine='__brp_mangle_shebangs'
RPMBUILD_EXTRA_ARGS_EOS
)

export QA_RPATHS="$(( 0x0002 ))"

[ "$#" -eq 0 ] && make rpm || eval "$@"
