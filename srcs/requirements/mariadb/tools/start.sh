#!/bin/bash

MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")

# 環境変数のチェック
if [ -z "$MYSQL_ROOT_PASSWORD" -o -z "$MYSQL_DATABASE" -o -z "$MYSQL_USER" -o -z "$MYSQL_PASSWORD" ]; then
  echo "Error: Missing required environment variables."
  exit 1
fi

# データベースディレクトリの初期化
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# MariaDBサーバーの起動
echo "Starting MariaDB server..."
mysqld --user=mysql &

# MariaDBサーバーの起動待ち
until mysqladmin ping -h"localhost" --silent; do
  echo "Waiting for MariaDB server to start..."
  sleep 1
done

# ルートパスワードの設定
if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
  echo "Setting root password..."
  mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
fi

# データベースとユーザーの作成
echo "Creating database and user..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

# # WordPress用のデータベースを作成
# echo "Creating WordPress database..."
# mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`wordpress\`;"

# MariaDBサーバーの停止
echo "Stopping MariaDB server..."
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

# MariaDBサーバーをフォアグラウンドで起動
echo "Starting MariaDB server..."
exec mysqld --user=mysql
