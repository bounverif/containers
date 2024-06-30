 #!/bin/bash
# set -x 

# Set the default values of the environment variables used by the script
CARLA_SERVER_RENDERING=${CARLA_SERVER_RENDERING:-"OFFSCREEN"}
CARLA_SERVER_NO_SOUND=${CARLA_SERVER_NO_SOUND:-"true"}
CARLA_SERVER_FRAME_PER_SECOND=${CARLA_SERVER_FRAME_PER_SECOND:-25}
CARLA_SERVER_QUALITY_LEVEL=${CARLA_SERVER_QUALITY_LEVEL:-"Low"}
CARLA_SERVER_RPC_PORT=${CARLA_SERVER_RPC_PORT:-"2000"}
CARLA_SERVER_STREAMING_PORT=${CARLA_SERVER_STREAMING_PORT:-"2001"}
CARLA_SERVER_ADDITIONAL_ARGS=${CARLA_SERVER_ADDITIONAL_ARGS:-""}

CARLA_SERVER_ARGS=${CARLA_SERVER_ARGS:-"-fps=${CARLA_SERVER_FRAME_PER_SECOND}"}

gpu_count=$(/usr/bin/nvidia-smi -L | grep -i GPU | wc -l)
echo "$gpu_count NVIDIA GPU(s) found"

if [ "$gpu_count" -eq 0 ] && [ "$CARLA_SERVER_RENDERING" != "NONE" ]; then
    echo "No NVIDIA GPU found, switching to CPU rendering"
    CARLA_SERVER_RENDERING="NONE"
fi

if [ "$CARLA_SERVER_RENDERING" = "NONE" ]; then
    CARLA_SERVER_RENDERING_ARGS="-nullrhi"
    echo "No rendering mode selected"
elif [ "$CARLA_SERVER_RENDERING" = "OFFSCREEN" ]; then
    CARLA_SERVER_RENDERING_ARGS="-RenderOffScreen -ResX=1 -ResY=1 -quality-level=${CARLA_SERVER_QUALITY_LEVEL}"
    echo "Offscreen rendering mode selected"
elif [ "$CARLA_SERVER_RENDERING" = "SERVER" ]; then
    CARLA_SERVER_RENDERING_ARGS="-quality-level=${CARLA_SERVER_QUALITY_LEVEL}"
    echo "Server rendering mode selected"
fi

CARLA_SERVER_ARGS="${CARLA_SERVER_ARGS} ${CARLA_SERVER_RENDERING_ARGS}"

if [ "$CARLA_SERVER_NO_SOUND" ]; then
    CARLA_SERVER_ARGS="${CARLA_SERVER_ARGS} -nosound"
fi

if [ "$CARLA_SERVER_ADDITIONAL_ARGS" ]; then
    CARLA_SERVER_ARGS="${CARLA_SERVER_ARGS} ${CARLA_SERVER_ADDITIONAL_ARGS}"
fi

echo "Starting CarlaUE4 with ${CARLA_SERVER_ARGS}"
exec /opt/carla-simulator/CarlaUE4/Binaries/Linux/CarlaUE4-Linux-Shipping ${CARLA_SERVER_ARGS}
