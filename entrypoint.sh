#!/usr/bin/env bash
set -e

# ensure that we are always running from the script location
export CMD="${BASH_SOURCE[0]}"
export BIN_DIR="${CMD%/*}"
cd "${BIN_DIR}"


ROOT_DIR="${ROOT_DIR:-/}"


err() {
  echo "ERR: $* exiting" >&2
  exit 1
}

[ -z "${RPM_NAME}" ]    && err "Please set RPM_NAME as a env var"
[ -z "${RPM_VERSION}" ] && err "Please set RPM_VERSION as a env var"
[ -z "${RPM_RELEASE}" ] && err "Please set RPM_RELEASE as a env var"

export RPMBUILD_DIST="$(rpm -E '%{dist}')"

if [ -z "${RPMBUILD_SPEC_FILE}" ]; then

  # since RPMBUILD_SPEC_FILE was not provided in the environment, we
  # force a naming standard.
  export RPMBUILD_SPEC_FILE="${RPM_NAME}.spec"

fi

if [ -z "${RPM_PACKAGE_NAME}" ]; then

  # since RPM_PACKAGE_NAME was not provided in the environment, we
  # force a naming standard.
  export RPM_PACKAGE_NAME="${RPM_NAME}-${RPM_VERSION}-${RPM_RELEASE}${RPMBUILD_DIST}"

fi

set -x
command -v rpmdev-setuptree >>/dev/null
rpmdev-setuptree

[ -f ${ROOT_DIR}/entrypoint.d/utils.sh ] && . "${ROOT_DIR}/entrypoint.d/utils.sh" || true

for entrypoint in $(find ${ROOT_DIR}/entrypoint.d/ -perm -u=rwx -type f | sort)
do
  # We only fire entrypoint scripts that are executable
  ./${entrypoint} || true

done
