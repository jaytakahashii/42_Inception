#!/bin/bash

# TLS証明書がない場合は自己署名証明書を生成
if [ ! -f /etc/nginx/certs/nginx.crt ]; then
  mkdir -p /etc/nginx/certs
  cp "$NGINX_CERT_FILE" /etc/nginx/certs/nginx.crt
  cp "$NGINX_KEY_FILE" /etc/nginx/certs/nginx.key
fi

envsubst '${SERVER_NAME} ${PHP_UPSTREAM}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Nginx起動
exec nginx -g "daemon off;"
