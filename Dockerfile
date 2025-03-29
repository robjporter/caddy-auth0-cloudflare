FROM golang:1.24-alpine AS builder

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN /go/bin/xcaddy build \
    --output /usr/bin/caddy \
    --with github.com/greenpau/caddy-security@v1.1.31 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
