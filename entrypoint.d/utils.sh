#!/usr/bin/env bash

export CMD="${BASH_SOURCE[0]}"
export BIN_DIR="${CMD%/*}"

cat <<ENV_VAR_EOS
**************** Environment Variables **************

CMD="${CMD}"
BIN_DIR="${BIN_DIR}'

BUILD_PACKAGES="${BUILD_PACKAGES}"

SRC_RPMS="${SRC_RPMS}"

RPM_NAME="${RPM_NAME}"
RPM_VERSION="${RPM_VERSION}"
RPM_RELEASE="${RPM_RELEASE}"
RPMBUILD_DIST="${RPMBUILD_DIST}"
RPM_PACKAGE_NAME="${RPM_PACKAGE_NAME}"

RPMBUILD_SPEC_FILE="${RPM_NAME}.spec"
RPMBUILD_EXTRA_ARGS="${RPMBUILD_EXTRA_ARGS}"

******************************************************
ENV_VAR_EOS
