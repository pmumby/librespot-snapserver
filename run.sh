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

# create default librespot config if it the original default pipe exists (fresh config file):
sed -i "s,^source =.*name=default,source = librespot:///librespot?name=Spotify\&devicename=$DEVICE_NAME\&bitrate=320\&volume=100$credentials," /config/snapserver.conf

# update the config to represent current intended behavior from env:
sed -i "s,^source = librespot.*,source = librespot:///librespot?name=Spotify\&devicename=$DEVICE_NAME\&bitrate=320\&volume=100$credentials," /config/snapserver.conf

# Switch to opus codec for better low latency networking
sed -i "s,^#codec = .*,codec = opus," /config/snapserver.conf

# and finally launch snapserver with the updated config...
exec snapserver -c /config/snapserver.conf
