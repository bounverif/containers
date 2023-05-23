#
# docker build -t bounverif/carla-server:0.9.14_RSS
# 
FROM ubuntu:focal as builder

ARG VERSION=0.9.14_RSS
ARG MAP_VERSION=0.9.14
ARG CARLA_RELEASE_NAME=CARLA_${VERSION}

ARG CARLA_RELEASE_TARBALL=https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/${CARLA_RELEASE_NAME}.tar.gz
ARG CARLA_ADDITIONAL_MAPS=https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/AdditionalMaps_${MAP_VERSION}.tar.gz

# Install core packages required to install from external repos
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        tar curl wget zip unzip gnupg2 \
        software-properties-common \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN mkdir /carla_release 
RUN wget -qO- ${CARLA_RELEASE_TARBALL} | tar xz -C /carla_release

FROM docker.io/nvidia/cuda:12.1.1-base-ubuntu20.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        sudo \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN groupadd carla -g 1000 \
   && useradd -ms /bin/bash carla -g 1000 -u 1000 \
   && printf "carla:carla" | chpasswd \
   && printf "carla ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

COPY --from=builder --chown=carla:carla /carla_release /opt/carla-simulator

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        libsdl2-2.0 xserver-xorg libvulkan1 libomp5 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

USER carla
WORKDIR /home/carla/

CMD /bin/bash /opt/carla-simulator/CarlaUE4.sh -RenderOffScreen -nosound
EXPOSE 2000 2001 2002