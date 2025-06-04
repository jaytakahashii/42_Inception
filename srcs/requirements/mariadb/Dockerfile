FROM debian:bullseye-slim

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y mariadb-server
RUN rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy the default configuration file
RUN rm /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copy the start script
COPY ./tools/start.sh /
RUN chmod +x /start.sh

EXPOSE 3306

ENTRYPOINT ["/start.sh"]
