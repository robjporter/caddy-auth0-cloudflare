# -------- Builder Stage --------
FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git

RUN xcaddy build \
    --output /caddy \
    --with github.com/greenpau/caddy-security@v1.1.31 \
    --with github.com/caddy-dns/cloudflare

# ✅ Sanity check immediately after build
RUN /caddy list-modules

# -------- Final Stage --------
FROM caddy:2.9.1

COPY --from=builder /caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
