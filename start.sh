#!/bin/sh

set -e

# Start goproxy
echo Starting Dockercraft
dockercraft -daemon &

# start Minecraft C++ server
cd /srv/world
cuberite
