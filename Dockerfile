# -------- Builder Stage --------
FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git curl

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN /go/bin/xcaddy build \
    --output /caddy \
    --with github.com/greenpau/caddy-security@v1.1.31 \
    --with github.com/caddy-dns/cloudflare

RUN /usr/bin/caddy list-modules | grep auth

# -------- Final Stage --------
FROM caddy:2.9.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
