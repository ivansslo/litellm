#!/bin/bash
# Bind ke $PORT yang dikasih Render, bukan port 11434 hardcoded.
export OLLAMA_HOST="0.0.0.0:${PORT:-11434}"

# Start server di background
ollama serve &
SERVE_PID=$!

# Tunggu server siap
until ollama list >/dev/null 2>&1; do
    sleep 1
done

# Pull model kecil sekali di awal (skip kalau sudah ada di disk persisten)
ollama pull "${OLLAMA_MODEL:-gpt-oss:20b}"

# Tetap foreground di proses server
wait $SERVE_PID
