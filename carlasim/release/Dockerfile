FROM docker.io/library/ubuntu:22.04 as carla-release

ARG CARLA_VERSION=0.9.15
ARG CARLA_RELEASE_SERVER=https://carla-releases.s3.us-east-005.backblazeb2.com/Linux
ARG CARLA_RELEASE_TAR=CARLA_${CARLA_VERSION}.tar.gz
ARG CARLA_RELEASE_URL=${CARLA_RELEASE_SERVER}/${CARLA_RELEASE_TAR}

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_CACHE_DIR=true
ENV PIP_DISABLE_PIP_VERSION_CHECK=true
ENV PIP_BREAK_SYSTEM_PACKAGES=true

ENV CARLA_VERSION=${CARLA_VERSION}
ENV CARLA_RELEASE_URL=${CARLA_RELEASE_URL}
ENV CARLA_ADDITIONAL_MAPS_URL=${CARLA_ADDITIONAL_MAPS_URL}

# Install core packages required to download files from external servers
RUN apt-get update && apt-get -y install --no-install-recommends \
        tar \
        curl \
        wget \
        zip \
        unzip \
        gnupg2 \
        software-properties-common \
    && apt-get autoremove -y && apt-get clean -y

RUN mkdir -p /carla_release && \ 
    wget -qO- ${CARLA_RELEASE_URL} | tar xz -C /carla_release

FROM carla-release as carla-release-extra

RUN wget -qO- ${CARLA_ADDITIONAL_MAPS_URL} | tar xz --keep-newer-files -C /carla_release
