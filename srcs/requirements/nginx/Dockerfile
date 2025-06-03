FROM debian:bookworm-slim

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y nginx openssl
RUN rm -rf /var/lib/apt/lists/*

COPY conf/ /etc/nginx/
COPY tools/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
