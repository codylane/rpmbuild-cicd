#!/usr/bin/env bash
set -e

install_src_rpms()
{

  if [ -n "${SRC_RPMS}" ]; then

    # ensure that the rpm command exists before we try to use it
    command -v rpm >>/dev/null

    # this is done as a loop to avoid problems with quoting
    for src_rpm in ${SRC_RPMS}
    do
      rpm -ivh "${src_rpm}" || true
    done

  fi
}

install_src_rpms
