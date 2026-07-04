#!/bin/bash
set -euo pipefail

# --- Tailscale (opsional, non-blocking, jalan di background) ---
if [ -f /app/docker/tailsup.sh ]; then
    bash /app/docker/tailsup.sh &
fi

# Render inject $PORT dinamis; jangan hardcode 4000.
exec litellm "$@" --port "${PORT:-4000}"
echo "Tailscaled script successfully!"
