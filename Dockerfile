# -------- Builder Stage --------
FROM golang:1.24-alpine AS caddy_builder

RUN apk add --no-cache git

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN /go/bin/xcaddy build \
    --output /caddy \
    --with github.com/greenpau/caddy-security@v1.1.31 \
    --with github.com/caddy-dns/cloudflare

# -------- Final Stage --------
FROM caddy:alpine

COPY --from=caddy_builder /caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
