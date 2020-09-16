#!/bin/bash
set -euo pipefail

# start avahi's dependency
service dbus start

# start avahi
service avahi-daemon start

# grab optional credentials from env if passed in:
credentials=""
if [[ -n "${USERNAME:-}" ]] && [[ -n "${PASSWORD:-}" ]]; then
  credentials="\&username=$USERNAME\&password=$PASSWORD"
fi

# update the config to represent current intended behavior from env:
sed -i "s,^stream = .*,stream = librespot:///librespot?name=Spotify\&devicename=$DEVICE_NAME\&bitrate=320\&volume=100$credentials," /config/snapserver.conf

# and finally launch snapserver with the updated config...
exec snapserver -c /config/snapserver.conf
