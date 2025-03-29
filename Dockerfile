# -------- Builder Stage --------
FROM golang:1.24-alpine AS caddy_builder

RUN apk add --no-cache git

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN /go/bin/xcaddy build \
    --output /caddy \
    --with github.com/greenpau/caddy-security=/caddy-security \
    --with github.com/greenpau/caddy-security/modules/handler/auth_portal=/caddy-security/modules/handler/auth_portal \
    --with github.com/greenpau/caddy-security/modules/handler/forward_auth=/caddy-security/modules/handler/forward_auth \
    --with github.com/greenpau/caddy-security/modules/auth/oauth2=/caddy-security/modules/auth/oauth2 \
    --with github.com/caddy-dns/cloudflare

RUN /caddy list-modules | grep auth

# -------- Final Stage --------
FROM caddy:alpine

COPY --from=caddy_builder /caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
