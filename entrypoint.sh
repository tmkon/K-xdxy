#!/bin/sh

# args
AUUID="86c0d574-7558-41d0-9deb-55199f876e73"
CADDYIndexPage="https://raw.githubusercontent.com/caddyserver/dist/master/welcome/index.html"
ParameterSSENCYPT="chacha20-ietf-poly1305"
PORT=80

# configs
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
wget $CADDYIndexPage -O /usr/share/caddy/index.html
cat /conf/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
cat /conf/xray.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/xray.json

# start
tor &
/xray -config /xray.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
