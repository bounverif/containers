ARG PYTHON_VERSION=3.8

FROM ubuntu:20.04 as builder
ARG VERSION=0.9.14

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        git \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN git clone --branch ${CARLA_VERSION} --depth 1 --single-branch https://github.com/carla-simulator/carla.git /carla

FROM python:$PYTHON_VERSION-slim
ARG VERSION=0.9.14

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        xserver-xorg \
        fontconfig \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install \
        carla==$VERSION \
        pygame \
        numpy

COPY --from=builder /carla/PythonAPI/examples /examples
