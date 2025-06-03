#!/bin/bash

# TLS証明書がない場合は自己署名証明書を生成
if [ ! -f /etc/nginx/certs/nginx.crt ]; then
  mkdir -p /etc/nginx/certs
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/CN=jtakahas.42.fr" \
    -keyout /etc/nginx/certs/nginx.key \
    -out /etc/nginx/certs/nginx.crt
fi

# Nginx起動
exec nginx -g "daemon off;"
