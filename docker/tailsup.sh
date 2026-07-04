#!/bin/bash
# Dipanggil dari entrypoint.sh sebagai background job.
# TIDAK BOLEH membuat container gagal start walau Tailscale gagal connect.

if [ -z "${TS_AUTHKEY}" ]; then
    echo "[tailscale] TS_AUTHKEY tidak diset, skip."
    exit 0
fi

if ! command -v tailscaled >/dev/null 2>&1; then
    echo "[tailscale] binary tidak ditemukan di image, skip."
    exit 0
fi

tailscaled --tun=userspace-networking \
    --socks5-server=localhost:1055 \
    --outbound-http-proxy-server=localhost:1055 \
    --state=/tmp/tailscaled.state \
    --socket=/tmp/tailscaled.sock &

for i in $(seq 1 10); do
    [ -S /tmp/tailscaled.sock ] && break
    sleep 1
done

tailscale --socket=/tmp/tailscaled.sock up \
    --authkey="${TS_AUTHKEY}" \
    --hostname="${TS_HOSTNAME:-litellm-render}" \
    || echo "[tailscale] gagal connect, lanjut tanpa tailscale."
