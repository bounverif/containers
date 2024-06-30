FROM nvidia/opengl:1.2-glvnd-runtime-ubuntu22.04 AS carla-server

ARG CARLA_VERSION=0.9.15
ARG CARLA_RELEASE_SERVER=https://carla-releases.s3.us-east-005.backblazeb2.com/Linux
ARG CARLA_RELEASE_TAR=CARLA_${CARLA_VERSION}.tar.gz
ARG CARLA_RELEASE_URL=${CARLA_RELEASE_SERVER}/${CARLA_RELEASE_TAR}
ARG CARLA_ADDITIONAL_MAPS_TAR=AdditionalMaps_${CARLA_VERSION}.tar.gz
ARG CARLA_ADDITIONAL_MAPS_URL=${CARLA_RELEASE_SERVER}/${CARLA_ADDITIONAL_MAPS_TAR}

ENV CARLA_VERSION=${CARLA_VERSION}
ENV CARLA_RELEASE_URL=${CARLA_RELEASE_URL}
ENV CARLA_ADDITIONAL_MAPS_URL=${CARLA_ADDITIONAL_MAPS_URL}

RUN set -eux; \
    apt-get update; \
    apt-get -y install --no-install-recommends \
      tar \
      wget \
      gnupg2 \
      software-properties-common \
      ; \
    apt-get autoremove -y && apt-get clean -y

RUN mkdir -p /opt/carla-simulator; \ 
    wget -qO- ${CARLA_RELEASE_URL} | tar xz --no-same-owner --no-same-permissions --mode 755 -C /opt/carla-simulator

RUN wget -qO- ${CARLA_ADDITIONAL_MAPS_URL} | tar xz --keep-newer-files --no-same-owner --no-same-permissions --mode 0755 -C /opt/carla-simulator

RUN set -eux; \ 
    apt-get update; \
    apt-get -qy install --no-install-recommends -o Dpkg::Options::="--force-confold" \
      sudo \
      supervisor \
      python3 \ 
      python3-pip \
      libsdl2-2.0 \
      libgl1 \
      libegl1 \
      libvulkan1 \
      vulkan-tools \
      valgrind \
      libomp5 \
      xdg-user-dirs \
      ; \
    apt-get autoremove -y && apt-get clean -y

COPY --chown=root:root --chmod=0755 carla.sh /etc/carla/carla.sh

ARG USER=bounverif
ARG USERGROUP=${USER}
ARG UID=1000
ARG GID=${UID}

RUN groupadd ${USERGROUP} -g ${GID}; \
    useradd -ms /bin/bash ${USER} -g ${USERGROUP} -u ${UID} -G sudo,video; \
    printf "${USER} ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

USER ${USER}
WORKDIR /home/${USER}

ENV DISPLAY=:0
ENV XDG_RUNTIME_DIR=/run/user/${UID}

RUN python3 -m pip install --user carla==${CARLA_VERSION}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/etc/carla/carla.sh"]

EXPOSE 2000 2001 2002