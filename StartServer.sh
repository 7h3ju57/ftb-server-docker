#!/bin/bash

OPS=""
MODPACK="FTB Presents SkyFactory 3"
PORT=25566
UPDATE="yes"

mkdir -p ./volumes && chown -R 1000:1000 ./volumes && chmod -R 777 ./volumes
docker run -it \
-v $(pwd)/volumes:/data \
-p "$PORT":25565 \
-e OPS="$OPS" \
-e MODPACK="$MODPACK" \
-e UPDATE="$UPDATE" \
--name "FTB-Server" 7h3ju57/ftb-server:1.2
