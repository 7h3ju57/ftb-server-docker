#!/bin/bash

OPS=""
MODPACK="SkyFactory 3"
PORT=25565

mkdir -p ./volumes && chown -Rv 1000:1000 ./volumes && chmod -Rv 777 ./volumes
docker run -d \
-v $(pwd)/volumes:/data \
-p "$PORT":25565 \
-e OPS="$OPS" \
-e MODPACK="$MODPACK" \
--name "$MODPACK" 7h3ju57/ftb-server:latest
