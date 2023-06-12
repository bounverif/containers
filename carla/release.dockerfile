FROM ubuntu:focal 

ARG VERSION=0.9.14
ARG CARLA_VERSION=$VERSION
ARG CARLA_RELEASE_NAME=CARLA_${VERSION}_RSS
ARG CARLA_RELEASE_TARBALL=https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/${CARLA_RELEASE_NAME}.tar.gz
ARG CARLA_ADDITIONAL_MAPS=https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/AdditionalMaps_${CARLA_VERSION}.tar.gz

# Install core packages required to install from external repos
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        tar curl wget zip unzip gnupg2 \
        software-properties-common \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN mkdir /carla_release 
RUN wget -qO- ${CARLA_RELEASE_TARBALL} | tar xz -C /carla_release
RUN wget -q -P /carla_release/Import ${CARLA_ADDITIONAL_MAPS} \
    && cd /carla_release && ./ImportAssets.sh \
    && rm ./Import/AdditionalMaps_${CARLA_VERSION}.tar.gz
