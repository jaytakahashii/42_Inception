NAME=srcs-mariadb
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
	docker rmi $(NAME) || true

fclean: clean
	docker rmi $(NAME) || true

rebuild: remove up

restart: down up
