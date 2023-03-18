#!/usr/bin/env bash

set -euxo pipefail

# Overwriting settings.json with environment variables
echo "Creating configuration file from environment variables"
/usr/local/bin/envsubst < /app/settings.json.tmpl > /config/settings.json

echo "Transmission starting with the following configuration..."
cat /config/settings.json

# shellcheck disable=SC2086
exec /app/transmission-daemon --foreground --config-dir /config --port "${WEBUI_PORT}" ${EXTRA_ARGS:-}
