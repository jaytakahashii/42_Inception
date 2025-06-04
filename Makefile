include srcs/.env
export

MARIADB_NAME=mariadb
WORDPRESS_NAME=wordpress
NGINX_NAME=nginx

COMPOSE=docker compose -f srcs/docker-compose.yml

.PHONY: all up down clean fclean rebuild remove restart ls prune help

all: up

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart: down up

ls:
	docker ps
	docker ps -a
	docker images
	docker volume ls
	docker network ls

clean:
	$(COMPOSE) down -v
	sudo rm -rf ${HOST_VOLUME_PATH}/wordpress/*
	sudo rm -rf ${HOST_VOLUME_PATH}/mariadb/*

remove: down
	docker rmi $(MARIADB_NAME) $(WORDPRESS_NAME) $(NGINX_NAME) || true

fclean: clean
	docker rmi $(MARIADB_NAME) $(WORDPRESS_NAME) $(NGINX_NAME) || true

rebuild: remove up

prune: fclean
	docker system prune -a

help:
	@echo "Makefile commands:"
	@echo "  all       - Build and start the containers"
	@echo "  up        - Start the containers in detached mode"
	@echo "  down      - Stop the containers"
	@echo "  restart   - Restart the containers"
	@echo "  ls        - List running containers, all containers, images, and volumes"

	@echo "\n--- NOTE: 'clean', 'fclean', 'rebuild', and 'remove' will delete volumes or images or both ---"
	@echo "  remove    - Down and remove the images"
	@echo "  clean     - Stop and remove containers, networks, and volumes created by up"
	@echo "  fclean    - Clean everything including images"
	@echo "  rebuild   - fclean and up"
	@echo "  prune     - Clean up unused containers, networks, images, and optionally volumes"
