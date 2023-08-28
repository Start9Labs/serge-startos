#!/bin/bash
set -e

read DURATION
if [ "$DURATION" -le 10000 ]; then
    exit 60
else
    CHCK='curl -skf http://localhost:8008 >/dev/null 2>&1'
    eval "$CHCK"
    exit_code=$?
    if [ "$exit_code" -ne 0 ]; then
        echo "Initializing Serge Chat ..."  >&2
        exit 61
        sleep 25
        eval "$CHCK"
        exit_code=$?
        if [ "$exit_code" -ne 0 ]; then
            echo "Serge Chat is unreachable" >&2
            exit 1
        fi
    fi
fi