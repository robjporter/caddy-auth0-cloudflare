# -------- Builder Stage --------
FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git curl

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN git clone --branch v1.1.31 https://github.com/greenpau/caddy-security /caddy-security

RUN /go/bin/xcaddy build \
    --output /caddy \
    --with github.com/greenpau/caddy-security=/caddy-security \
    --with github.com/caddy-dns/cloudflare
    
# ✅ Sanity check immediately after build
RUN /caddy list-modules | grep -E 'auth_portal|forward_auth|oauth2'

# -------- Final Stage --------
FROM caddy:2.9.1

COPY --from=builder /caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
