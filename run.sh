#!/bin/bash
set -euo pipefail

credentials=""
if [[ -n "${USERNAME:-}" ]] && [[ -n "${PASSWORD:-}" ]]; then
  credentials="\&username=$USERNAME\&password=$PASSWORD"
fi

sed -i "s,^stream = .*,stream = librespot:///librespot?name=Spotify\&devicename=$DEVICE_NAME\&bitrate=320\&volume=100$credentials," /config/snapserver.conf

exec snapserver -c /config/snapserver.conf
