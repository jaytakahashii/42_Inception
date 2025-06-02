FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-cli \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-soap \
    php8.2-intl \
    php8.2-zip \
    wget \
    unzip \
    curl \
    mariadb-client
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

# Install WordPress
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
RUN tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
RUN rm /tmp/wordpress.tar.gz

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Install wp-cli
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/local/bin/wp

# start.sh script
COPY ./tools/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
