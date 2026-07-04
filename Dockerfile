FROM ghcr.io/berriai/litellm:main-stable

ARG TAILSCALE_VERSION=1.98.8
RUN apk add --no-cache curl ca-certificates bash tar && \
    mkdir -p /tmp/ts && \
    curl -v -L -o /tmp/tailscale.tgz "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION}_amd64.tgz" && \
    ls -la /tmp/tailscale.tgz && \
    tar -xzvf /tmp/tailscale.tgz -C /tmp/ts --strip-components=1 && \
    ls -la /tmp/ts && \
    mv /tmp/ts/tailscale /tmp/ts/tailscaled /usr/local/bin/ && \
    rm -rf /tmp/ts /tmp/tailscale.tgz

WORKDIR /app

COPY config.yaml .
COPY docker/entrypoint.sh docker/tailsup.sh /app/docker/
RUN chmod +x /app/docker/entrypoint.sh /app/docker/tailsup.sh

ENTRYPOINT ["/app/docker/entrypoint.sh"]
CMD ["--config", "/app/config.yaml"]
