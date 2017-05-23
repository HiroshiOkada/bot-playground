#!/bin/sh

MAX_FSIZE=$(( 4096 * 1024))
MAX_DSIZE=$(( 1024 * 1024))
MAX_CPU="30"

WORKER_ID=$$
EXEC_CONtINER=bot-"$WORKER_ID"

cd `dirname "$0"`
cd ..

docker run --rm -it --network=none \
                    --ulimit fsize="$MAX_FSIZE" \
                    --ulimit data="$MAX_DSIZE" \
                    --ulimit cpu="$MAX_CPU" \
                    --hostname "$EXEC_CONtINER" \
                    --name "$EXEC_CONtINER" bot-playground bash

