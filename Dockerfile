FROM rust:1.45 AS librespot

RUN apt-get update \
 && apt-get -y install build-essential portaudio19-dev curl unzip \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG ARCH=amd64
ARG LIBRESPOT_VERSION=0.1.3

COPY ./install-librespot.sh /tmp/
RUN /tmp/install-librespot.sh

FROM debian:bullseye

ARG SNAPCAST_VERSION=0.21.0

RUN apt-get update \
 && apt-get -y install libasound2 mpv avahi-daemon libnss-mdns wget \
 && apt-get clean && rm -fR /var/lib/apt/lists

RUN wget -O /tmp/snapserver.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}-1_amd64.deb

RUN dpkg -i /tmp/snapserver.deb

COPY --from=librespot /usr/local/cargo/bin/librespot /usr/local/bin/

COPY run.sh /
CMD ["/run.sh"]

RUN mkdir /config && cp /etc/snapserver.conf /config/snapserver.conf

ENV DEVICE_NAME=Snapcast
EXPOSE 1704/tcp 1705/tcp
VOLUME /config