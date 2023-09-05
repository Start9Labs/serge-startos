#!/bin/sh

read DURATION
if [ "$DURATION" -le 30000 ]; then
    exit 60
else
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
fi