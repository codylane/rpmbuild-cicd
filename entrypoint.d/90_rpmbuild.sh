#!/usr/bin/env bash
set -e

# note, you can override these variables via env variables
# but also contain sane defaults.
RPMBUILD_HOME="${RPMBUILD_HOME:-${HOME}/rpmbuild}"

# sync the mounted volume data to the local disk
echo "Syncing volume bits to local disk..."
rsync -a /rpmbuild/SPECS/   ${RPMBUILD_HOME}/SPECS/
rsync -a /rpmbuild/SOURCES/ ${RPMBUILD_HOME}/SOURCES/

eval rpmbuild                                         \
  -ba "${RPMBUILD_HOME}/SPECS/${RPMBUILD_SPEC_FILE}"  \
  "${RPMBUILD_EXTRA_ARGS[@]}"

# sync new bits back to our volume
rsync -a ${RPMBUILD_HOME}/RPMS/   /rpmbuild/RPMS/
rsync -a ${RPMBUILD_HOME}/SRPMS/ /rpmbuild/SRPMS/
