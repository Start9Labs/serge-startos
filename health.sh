#!/bin/sh

read DURATION

if [ "$DURATION" -le 30000 ]; then
    exit 60
fi

CHCK='curl -sf http://localhost:8008/api/ping/ >/dev/null 2>&1'
eval "$CHCK"
exit_code=$?
if [ "$exit_code" -ne 0 ]; then
    echo "Initializing Serge Chat ..."  >&2
    exit 61
    sleep 5
    eval "$CHCK"
    exit_code=$?
    if [ "$exit_code" -ne 0 ]; then
        echo "Serge Chat is unreachable" >&2
        exit 1
    fi
fi

if [ -f /usr/src/app/curl.txt ]; then
    echo "Cool" > /dev/null
else
    while ! curl -sf http://localhost:8008/api/ping/ >/dev/null 2>&1; do
        sleep 5
    done

    total_memory_gb=$(awk '/MemAvailable/{print int($2 / 1024 / 1024)}' /proc/meminfo)

    if [ "$total_memory_gb" -gt 8 ]; then
        new_url="https://raw.githubusercontent.com/Start9Labs/serge-startos/weights/models-big.json"
    else
        new_url="https://raw.githubusercontent.com/Start9Labs/serge-startos/weights/models-small.json"
    fi

    curl -X POST "http://localhost:8008/api/model/refresh" \
         -H "Content-Type: multipart/form-data" \
         -F "url=$new_url"

    echo "$(date) - The curl command was executed" >> /usr/src/app/curl.txt
    sed -i "s#https://raw.githubusercontent.com/serge-chat/serge/main/api/src/serge/data/models.json#$new_url#" /usr/src/app/api/static/_app/immutable/nodes/4.*.js
    sed -i "s#col-span-3 flex flex-col#col-span-3 flex flex-col hidden#" /usr/src/app/api/static/_app/immutable/nodes/2.*.js
fi