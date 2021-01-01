#!/usr/bin/env bash
set -e

[ -f /etc/profile.d/acceptance-rubies.sh ] && . /etc/profile.d/acceptance-rubies.sh

cd /acceptance
[ "$#" -eq 0 ] && rake spec || eval "$@"
