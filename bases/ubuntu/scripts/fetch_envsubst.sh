#!/bin/bash

set -euxo pipefail

ENVSUBST_VERSION=$1

if [ "$TARGETPLATFORM" = "linux/arm64" ]; then
    export ENVSUBST_URL="https://github.com/a8m/envsubst/releases/download/${ENVSUBST_VERSION}/envsubst-Linux-arm64"
elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    export ENVSUBST_URL="https://github.com/a8m/envsubst/releases/download/${ENVSUBST_VERSION}/envsubst-Linux-amd64"
fi

curl "${ENVSUBST_URL}" --output /usr/local/bin/envsubst
