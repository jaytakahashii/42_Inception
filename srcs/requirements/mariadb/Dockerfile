FROM debian:bookworm-slim

# package update and upgrade
RUN apt-get update -y
RUN apt-get upgrade -y

# install mariadb server
RUN apt-get install -y mariadb-server

# remove apt cache
RUN rm -rf /var/lib/apt/lists/*

# create necessary directories
RUN mkdir -p /run/mysqld

# set permissions
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

# copy the default configuration file
RUN rm /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# copy the start script
COPY ./tools/start.sh /
RUN chmod +x /start.sh

# expose the port
EXPOSE 3306

ENTRYPOINT ["/start.sh"]
