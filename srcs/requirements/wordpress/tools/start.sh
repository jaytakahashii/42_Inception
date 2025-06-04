#!/bin/bash
set -e

DB_NAME=$WP_DATABASE
DB_USER=$WP_USER
DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")
DB_HOST=$DB_HOST
SITE_URL=$WORDPRESS_URL
SITE_TITLE=$WORDPRESS_TITLE
ADMIN_USER=$WORDPRESS_ADMIN_USER
ADMIN_PASS=$(cat "$WORDPRESS_ADMIN_PASSWORD_FILE")
ADMIN_EMAIL=$WORDPRESS_ADMIN_EMAIL
USER_USER=$WORDPRESS_USER_USER
USER_PASS=$(cat "$WORDPRESS_USER_PASSWORD_FILE")
USER_EMAIL=$WORDPRESS_USER_EMAIL

cd /var/www/html

if [ ! -f wp-load.php ]; then
  echo "Downloading WordPress..."
  wp core download --allow-root
fi

# set up wp-config.php
if [ ! -f wp-config.php ]; then
  echo "Creating wp-config.php..."
  wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$DB_HOST" \
    --allow-root
fi

# install WordPress if not already installed
if ! wp core is-installed --allow-root; then
  echo "Installing WordPress..."
  wp core install \
    --url="$SITE_URL" \
    --title="$SITE_TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASS" \
    --admin_email="$ADMIN_EMAIL" \
    --skip-email \
    --allow-root
fi

# create admin user if it does not exist
if ! wp user get "$USER_USER" --allow-root > /dev/null 2>&1; then
  echo "Creating regular user..."
  wp user create "$USER_USER" "$USER_EMAIL" \
    --user_pass="$USER_PASS" \
    --role=subscriber \
    --allow-root
fi

exec php-fpm7.4 -F
