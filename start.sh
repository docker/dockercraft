# Start goproxy
goproxy &> /srv/world/goproxy_out &

# start Minecraft C++ server
cd /srv/world
../Server/Cuberite
