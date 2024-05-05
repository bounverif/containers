# Containerized AWSIM simulator

This container is based on `ghcr.io/selkies-project/nvidia-egl-desktop`, which provides a WebRTC solution for containerized GUI apps. 

1. First start the container using the following command:

```
docker run --gpus 1 --tmpfs /dev/shm:rw -p 8080:8080 ghcr.io/bounverif/awsim-desktop:1.2.1
```

2. Open a browser and visit `localhost:8080`. The simulator window will appear in the browser. Then you can control the vehicle using the keyboard.