#!/bin/sh

exec /usr/bin/dumb-init -- /bin/bash -c "/usr/src/app/deploy.sh"
