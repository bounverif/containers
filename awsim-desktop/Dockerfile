FROM ubuntu:22.04 as awsim-downloader

ARG VERSION=1.2.1
ARG AWSIM_VERSION=$VERSION
ARG AWSIM_RELEASE_PATH=https://github.com/tier4/AWSIM/releases/download/v${AWSIM_VERSION}/AWSIM_v${AWSIM_VERSION}.zip
ARG AWSIM_ADDITIONAL_MAPS=https://github.com/tier4/AWSIM/releases/download/v${AWSIM_VERSION}/nishishinjuku_autoware_map.zip

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        wget \
        unzip \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN wget -qO /tmp/awsim_release.zip ${AWSIM_RELEASE_PATH} && \
    unzip /tmp/awsim_release.zip -d /awsim && \
    rm /tmp/awsim_release.zip

FROM ghcr.io/selkies-project/nvidia-egl-desktop:22.04 as awsim-desktop

SHELL ["/bin/bash", "-c"]

ARG VERSION=1.2.1
ARG AWSIM_VERSION=$VERSION

ENV TZ=UTC
ENV SIZEW=1920 SIZEH=1080
ENV WEBRTC_ENCODER=nvh264enc
ENV WEBRTC_ENABLE_RESIZE true
ENV ENABLE_BASIC_AUTH false

COPY --from=awsim-downloader --chown=root:root /awsim/AWSIM_v${AWSIM_VERSION} /opt/awsim

COPY entrypoint.sh /etc/entrypoint.sh
RUN sudo chmod +x /etc/entrypoint.sh

EXPOSE 8080
