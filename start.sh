# Start goproxy
cd /go/src/goproxy
./goproxy &> out &

# start Minecraft C++ server
cd /srv/world
../MCServer/MCServer -d

/bin/bash

# ../MCServer/MCServer