#!/bin/bash

set -euxo pipefail

ENVSUBST_VERSION=$1

if [ "$TARGETPLATFORM" = "linux/arm64" ]; then
    export ENVSUBST_URL="https://github.com/a8m/envsubst/releases/download/${ENVSUBST_VERSION}/envsubst-Linux-arm64"
elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    export ENVSUBST_URL="https://github.com/a8m/envsubst/releases/download/${ENVSUBST_VERSION}/envsubst-Linux-x86_64"
fi

exec curl -L "${ENVSUBST_URL}" --output /usr/local/bin/envsubst
