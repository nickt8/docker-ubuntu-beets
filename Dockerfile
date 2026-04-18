# syntax=docker/dockerfile:1

ARG BASE_TAG=noble
FROM ghcr.io/linuxserver/baseimage-ubuntu:${BASE_TAG}

# set version label
ARG BEETS_VERSION

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  echo "**** install build packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libcairo2-dev \
    pkg-config \
    python3-dev && \
  echo "**** install runtime packages ****" && \
  apt-get install -y --no-install-recommends \
    libchromaprint1 \
    ffmpeg \
    flac \
    gobject-introspection \
    imagemagick \
    lame \
    libgirepository-2.0-dev \
    mp3gain \
    mp3val \
    mpg123 \
    nano \
    python3-venv && \
  echo "**** install beets ****" && \
  if [ -z ${BEETS_VERSION+x} ]; then \
    BEETS_VERSION=$(curl -sL https://pypi.org/pypi/beets/json | jq -r '.info.version'); \
  fi && \
  git clone --depth 1 --branch "v${BEETS_VERSION}" https://github.com/beetbox/beets.git /tmp/beets && \
  cd /tmp/beets && \
  echo "**** install pip packages ****" && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    setuptools \
    wheel && \
  echo "**** install beets ****" && \
  cd /tmp/beets && \
  pip install -U --no-cache-dir . && \
  echo "**** install pip packages ****" && \
  pip install -U --no-cache-dir \
    beautifulsoup4 \
    flask \
    flask-cors \
    PyGObject \
    pyacoustid \
    pylast \
    python3-discogs-client \
    requests \
    requests_oauthlib \
    typing-extensions \
    unidecode && \
  echo "**** cleanup ****" && \
  apt-get autoremove -y \
    build-essential \
    cmake \
    git \
    libcairo2-dev \
    pkg-config \
    python3-dev && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    $HOME/.cache \
    $HOME/.cargo

# environment settings
ENV BEETSDIR="/config" \
  EDITOR="nano" \
  HOME="/config"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8337
VOLUME /config
