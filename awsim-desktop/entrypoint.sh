#!/bin/bash -e

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

trap "echo TRAPed signal" HUP INT QUIT TERM

# Start DBus without systemd
sudo /etc/init.d/dbus start

# Default display is :0 across the container
export DISPLAY=":0"
# Run Xvfb server with required extensions
/usr/bin/Xvfb "${DISPLAY}" -ac -screen "0" "8192x4096x${CDEPTH}" -dpi "${DPI}" +extension "COMPOSITE" +extension "DAMAGE" +extension "GLX" +extension "RANDR" +extension "RENDER" +extension "MIT-SHM" +extension "XFIXES" +extension "XTEST" +iglx +render -nolisten "tcp" -noreset -shmem &

# Wait for X11 to start
echo "Waiting for X socket"
until [ -S "/tmp/.X11-unix/X${DISPLAY/:/}" ]; do sleep 1; done
echo "X socket is ready"

# Resize the screen to the provided size
bash -c ". /opt/gstreamer/gst-env && /usr/local/bin/selkies-gstreamer-resize ${SIZEW}x${SIZEH}"

# Start Fcitx input method framework
/usr/bin/fcitx &

# Add custom processes right below this line, or within `supervisord.conf` to perform service management similar to systemd
exec /opt/awsim/AWSIM.x86_64 -screen-fullscreen &

echo "Session Running. Press [Return] to exit."
read