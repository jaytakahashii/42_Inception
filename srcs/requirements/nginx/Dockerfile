FROM debian:bookworm-slim

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y nginx openssl
RUN rm -rf /var/lib/apt/lists/*

# Copy the default configuration file
COPY conf/ /etc/nginx/

# Copy the start script
COPY tools/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 443

CMD ["/start.sh"]
