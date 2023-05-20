ARG VERSION=0.9.14_RSS
FROM ghcr.io/bounverif/carla-server:${VERSION} as builder

FROM python:3.7-slim 

# Add a container user (good practice)
RUN groupadd carla -g 1000 \
   && useradd -ms /bin/bash carla -g 1000 -u 1000 \
   && printf "carla:carla" | chpasswd \
   && printf "carla ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

COPY --from=builder --chown=carla:carla \
    /opt/carla-simulator/PythonAPI/carla/dist/carla-0.9.14-cp37-cp37m-linux_x86_64.whl \
    /opt/carla-simulator/PythonAPI/carla/dist/carla-0.9.14-cp37-cp37m-linux_x86_64.whl

COPY --from=builder --chown=carla:carla \
    /opt/carla-simulator/PythonAPI/examples \
    /examples

USER carla
WORKDIR /home/carla/

RUN pip install --upgrade pip \
    && pip install /opt/carla-simulator/PythonAPI/carla/dist/carla-0.9.14-cp37-cp37m-linux_x86_64.whl \
    && pip install pygame numpy scipy
