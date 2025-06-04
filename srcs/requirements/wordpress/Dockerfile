FROM debian:bullseye-slim

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-cli \
    php7.4-curl \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-soap \
    php7.4-intl \
    php7.4-zip \
    wget \
    unzip \
    curl \
    mariadb-client \
    net-tools \
    iproute2
RUN rm -rf /var/lib/apt/lists/*

# Install WordPress
RUN mkdir -p /var/www/html
RUN mkdir -p /run/php
WORKDIR /var/www/html
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
RUN tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
RUN rm /tmp/wordpress.tar.gz

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Install wp-cli
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/local/bin/wp

# Configure PHP-FPM
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Copy the start script
COPY ./tools/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
