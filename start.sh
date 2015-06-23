cd /srv/world

# Start goproxy
/go/src/goproxy/goproxy &

# start Minecraft C++ server
../MCServer/MCServer -d

/bin/bash

# ../MCServer/MCServer