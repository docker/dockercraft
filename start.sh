#!/bin/sh

set -e

# Start goproxy
echo Starting Dockercraft
dockercraft &

# start Minecraft C++ server
cd /srv/world
cuberite
