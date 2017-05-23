#!/bin/bash

CONTAINER_NAME=bot-playground-test
MAX_FSIZE=$(( 4096 * 1024))
MAX_DSIZE=$(( 2048 * 1024))
MAX_CPU="15"

EXPECT="hello, world"

cd `dirname "$0"`
cd ../hello-src/

docker kill "$CONTAINER_NAME" 2>/dev/null
docker rm "$CONTAINER_NAME" 2>/dev/null

for f in [Hh]ello.*
do
  echo "$f"
  docker run -d -it \
               --ulimit fsize="$MAX_FSIZE" \
               --ulimit data="$MAX_DSIZE" \
               --ulimit cpu="$MAX_CPU" \
               --name "$CONTAINER_NAME" \
               --network=none \
               bot-playground tail -f

    chmod "777" "$f"
    docker cp "$f" "$CONTAINER_NAME":/home/bot/"$f"

    export OUTPUT
    time OUTPUT=$(/usr/bin/timeout 32s docker exec "$CONTAINER_NAME"  timeout "$MAX_CPU"s /usr/local/bin/job.sh "$f" 2>&1 | head -2000)

    docker cp "$CONTAINER_NAME":/home/bot/out.png "$IMAGE_FILE_NAME" 2>/dev/null || true
    docker kill "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"

    echo "$OUTPUT"
    if [[ "$OUTPUT" =~ $EXPECT ]]; then
      echo "OK"
    else
      echo "NG"
      echo "expect" _"$EXPECT"_
      echo "actual" _"$OUTPUT"_
      echo "$f"
      exit
    fi
done

