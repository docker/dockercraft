# Start goproxy
goproxy &> /srv/world/goproxy_out &

# start Minecraft C++ server
cd /srv/world
../MCServer/MCServer -d

/bin/bash

# ../MCServer/MCServer