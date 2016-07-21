# Download the version of the docker client that matches the docker daemon present
gosetup

# Start goproxy
goproxy &> /srv/world/goproxy_out &

# start Minecraft C++ server
cd /srv/world

# GOPROXY DEVELOPMENT: start cuberite as a daemon
#../cuberite_server/Cuberite -d
../cuberite_server/Cuberite

/bin/bash