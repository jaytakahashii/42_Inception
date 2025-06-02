MARIADB_NAME=srcs-mariadb
WORDPRESS_NAME=srcs-wordpress
COMPOSE=docker compose -f srcs/docker-compose.yml

.PHONY: all up down clean fclean rebuild remove restart ls

all: up

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

ls:
	docker ps
	docker ps -a
	docker images
	docker volume ls

remove: down
	docker rmi $(MARIADB_NAME) $(WORDPRESS_NAME) || true

fclean: clean
	docker rmi $(MARIADB_NAME) $(WORDPRESS_NAME) || true

rebuild: remove up

restart: down up

help:
	@echo "Makefile commands:"
	@echo "  all       - Build and start the containers"
	@echo "  up        - Start the containers in detached mode"
	@echo "  down      - Stop the containers"
	@echo "  clean     - Stop and remove containers, networks, and volumes created by up"
	@echo "  fclean    - Clean everything including images"
	@echo "  rebuild   - Rebuild the images and start the containers"
	@echo "  remove    - Down and remove the images"
	@echo "  restart   - Restart the containers"
	@echo "  ls        - List running containers, all containers, images, and volumes"
