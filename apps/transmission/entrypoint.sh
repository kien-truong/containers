#!/usr/bin/env bash

set -euxo pipefail

# Update settings.json with environment variables if the file does not exists
FILE=/config/settings.json
if [[ -f "$FILE" ]]; then
    echo "$FILE exists, environment variables will not be used"
else
    echo "Creating configuration file from environment variables"
    /usr/local/bin/envsubst < /app/settings.json.tmpl > /config/settings.json
fi

echo "Transmission starting with the following configuration..."
cat /config/settings.json

# shellcheck disable=SC2086
exec /app/transmission-daemon --foreground --config-dir /config --port "${WEBUI_PORT}" ${EXTRA_ARGS:-}
