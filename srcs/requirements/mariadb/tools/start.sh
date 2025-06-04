#!/bin/bash

DB_ROOT_PASSWORD=$(cat "$DB_ROOT_PASSWORD_FILE")
DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")

if [ -z "$DB_ROOT_PASSWORD" -o -z "$WP_DATABASE" -o -z "$WP_USER" -o -z "$DB_PASSWORD" ]; then
  echo "Error: Missing required environment variables."
  exit 1
fi

# init MariaDB data directory if it does not exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting MariaDB server..."
mysqld --user=mysql &

# Wait for the MariaDB server to start
until mysqladmin ping -h"localhost" --silent; do
  echo "Waiting for MariaDB server to start..."
  sleep 1
done

# set the root password if provided
if [ -n "$DB_ROOT_PASSWORD" ]; then
  echo "Setting root password..."
  mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
fi

# Create the WordPress database and user
echo "Creating database and user..."
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${WP_DATABASE}\`;"
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${WP_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${WP_DATABASE}\`.* TO '${WP_USER}'@'%';"
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

# Stop the MariaDB server gracefully
echo "Stopping MariaDB server..."
mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown

# Restart the MariaDB server (Foreground mode)
echo "Starting MariaDB server..."
exec mysqld --user=mysql
