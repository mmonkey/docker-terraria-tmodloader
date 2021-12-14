#!/bin/bash
set -euo pipefail

CMD="./tModLoaderServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt"

# Create default config files if they don't exist
if [ ! -f "/config/serverconfig.txt" ]; then
    cp ./serverconfig-default.txt /config/serverconfig.txt
fi

if [ ! -f "/config/banlist.txt" ]; then
    touch /config/banlist.txt
fi

# Link ModLoader folder to /ModLoader so it will save to the correct location
if [ ! -s "/root/.local/share/Terraria/ModLoader" ]; then
	mkdir -p /root/.local/share/Terraria
    ln -sT /ModLoader /root/.local/share/Terraria/ModLoader
fi

# Pass in world if set
if [ "${WORLD:-null}" != null ]; then
    if [ ! -f "/ModLoader/Worlds/$WORLD" ]; then
        echo "World file does not exist! Quitting..."
        exit 1
    fi
    CMD="$CMD -world /ModLoader/Worlds/$WORLD"
fi

echo "Starting container, CMD: $CMD $@"
exec $CMD $@