# -------- Builder Stage --------
FROM caddy:2.9.1-builder AS builder

RUN xcaddy build \
    --output /usr/bin/caddy \
    --with github.com/greenpau/caddy-security@v1.1.31 \
    --with github.com/caddy-dns/cloudflare

RUN /usr/bin/caddy list-modules | grep auth

# -------- Final Stage --------
FROM caddy:2.9.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
