ARG CARLA_VERSION=0.9.15
FROM ghcr.io/bounverif/carla:release-${CARLA_VERSION} as carla-release

FROM docker.io/library/ubuntu:22.04 as carla-server

ARG USER=bounverif
ARG USERGROUP=${USER}
ARG UID=1000
ARG GID=${UID}

ARG CARLA_VERSION=0.9.15
ENV CARLA_VERSION=${CARLA_VERSION}

RUN apt-get update && apt-get -y install --no-install-recommends \
      supervisor \
      python3 \ 
      python3-pip \
      libsdl2-2.0 \
      libgl1 \
      libegl1 \
      libvulkan1 \
      vulkan-tools \
      libomp5 \
      xdg-user-dirs \
    && apt-get autoremove -y && apt-get clean -y

COPY --chown=root:root --chmod=755 --from=carla-release /carla_release /opt/carla-simulator/
COPY --chown=root:root --chmod=755 supervisord.conf /etc/supervisord.conf
COPY --chown=root:root --chmod=755 entrypoint.sh /etc/entrypoint.sh

RUN groupadd ${USERGROUP} -g ${GID} && useradd -ms /bin/bash ${USER} -g ${USERGROUP} -u ${UID} -G sudo

USER ${USER}
WORKDIR ${HOME}

RUN python3 -m pip install --user carla==${CARLA_VERSION}

ENV DISPLAY :0
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV XDG_RUNTIME_DIR /run/user/${UID}
ENV SDL_VIDEODRIVER=x11

ENV CARLA_SERVER_ARGS="-RenderOffScreen -ResX=1 -ResY=1 -nosound -quality-level=Low"
ENV CARLA_SERVER_MAP="Town05"

ENTRYPOINT ["/usr/bin/supervisord"]

EXPOSE 2000 2001 2002










FROM docker.io/library/ubuntu:22.04 as carla-client

ARG CARLA_VERSION=0.9.15
ENV CARLA_VERSION=${CARLA_VERSION}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        python3 \ 
        python3-pip \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install numpy pygame carla==${CARLA_VERSION} 
