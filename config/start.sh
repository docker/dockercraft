#!/bin/sh

set -e

biome="Plains"
groundlevel="62"
sealevel="0"
finishers=""

if [ -n "$1" ]; then
    biome="$1"
fi

if [ -n "$2" ]; then
    groundlevel="$2"
fi

if [ -n "$3" ]; then
    sealevel="$3"
fi

if [ -n "$4" ]; then
    finishers="$4"
fi

sed -i "s/@BIOME@/${biome}/g;s/@GROUNDLEVEL@/${groundlevel}/g;s/@SEALEVEL@/${sealevel}/g;s/@FINISHERS@/${finishers}/g" /srv/Server/world/world.ini

echo Starting Dockercraft
cd /srv/Server
dockercraft &
sleep 5
./Cuberite
