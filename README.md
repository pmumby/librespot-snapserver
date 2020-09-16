# librespot-snapserver

Run a [Snapcast](https://github.com/badaix/snapcast) server with [Spotify support](https://github.com/plietar/librespot) as a Docker container.

_Note: You need a Spotify premium account._

Uses Opus codec by default, for support of ESP32 based multi-room speaker setup.
Modified to support Avahi, for mdns auto-discovery of snapcast server on network. (likely need to run in privileged mode!) still sorting that part out.
This also allows auto-discovery of spotify connect from any spotify client on the same network
Need to use host networking for avahi to work correctly (both for snapcast and librespot for spotify connect)

## Usage

Run it like this:

    docker run -d --name snapserver --net host -e DEVICE_NAME=Snapcast pmumby/librespot-snapserver

That will make the device available to all Spotify clients in your network. Add your Spotify credentials in order to limit control to clients logged in with your account:

    docker run -d --name snapserver --net host -e DEVICE_NAME=Snapcast -e USERNAME=my-spotify-username -e PASSWORD=my-spotify-password pmumby/librespot-snapserver

Now you can connect your snapclient to your host's ip. The receiver should show up in Spotify under the `DEVICE_NAME` given above (e.g. `Snapcast`). Have fun playing music!

## Building the images

This image has been re-worked to support dockerhub auto-building