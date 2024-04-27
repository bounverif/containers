FROM python:3.10

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y \
        sudo \
        git \
        build-essential \
        cmake \
        ninja-build \
        cyclonedds-tools \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/eclipse-cyclonedds/cyclonedds.git /tmp/cyclonedds && \
    cmake -S/tmp/cyclonedds -B/tmp/cyclonedds/build && \
    cmake --build /tmp/cyclonedds/build --target install && \
    rm -rf /tmp/cyclonedds

RUN git clone https://github.com/eclipse-cyclonedds/cyclonedds-cxx.git /tmp/cyclonedds-cxx && \
    cmake -S/tmp/cyclonedds-cxx -B/tmp/cyclonedds-cxx/build && \
    cmake --build /tmp/cyclonedds-cxx/build --target install && \
    rm -rf /tmp/cyclonedds-cxx

RUN python3 -m pip install --no-cache-dir cyclonedds
