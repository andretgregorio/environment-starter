ROOT_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOCKER_DIR := $(ROOT_DIR)/docker
DOCKER_FILE := $(DOCKER_DIR)/docker-compose.yml

.DEFAULT_TARGET: docker

.PHONY: prepare-environment
prepare-environment:
	@rm -rf .env
	@touch .env
	@DB_USER=$(or $(DB_USER), $(shell read -p "Postgres User: " user; echo "DB_USER="$$user)); \
	DB_PASS=$(or $(DB_PASS), $(shell read -p "Postgres Pass: " pass; echo "DB_PASS="$$pass)); \
	printf "$$DB_USER\n$$DB_PASS\n" >> .env

.PHONY: docker
docker: prepare-environment
	@echo "Creando las instancias de docker para PostgreSQL, Redis y Kafka"
	@docker-compose -f $(DOCKER_FILE) --project-directory $(DOCKER_DIR) up -d

.PHONY: docker-stop
docker-stop:
	docker-compose -f $(DOCKER_FILE) down -v

.PHONY: producer
producer:
	@TOPIC=$(or $(TOPIC), $(shell read -p "Topico: " topic; echo $$topic)); \
	docker-compose -f $(DOCKER_FILE) exec kafka \
		kafka-console-producer --broker-list localhost:9092 --topic $$TOPIC

.PHONY: consumer
consumer:
	@TOPIC=$(or $(TOPIC), $(shell read -p "Topico: " topic; echo $$topic)); \
	docker-compose -f $(DOCKER_FILE) exec kafka \
		kafka-console-consumer --bootstrap-server localhost:9092 --topic $$TOPIC

.PHONY: redis-get
redis-get:
	@KEY=$(or $(KEY), $(shell read -p "Clave: " key; echo $$key)); \
	docker-compose -f $(DOCKER_FILE) exec redis \
		redis-cli GET '$$KEY'

.PHONY: redis-set
redis-set:
	@KEY=$(or $(KEY), $(shell read -p "Clave: " key; echo $$key)); \
	VALUE=$(or $(VALUE), $(shell read -p "Valor: " value; echo $$value)); \
	docker-compose -f $(DOCKER_FILE) exec redis \
		redis-cli SET '$$KEY' $$VALUE

.PHONY: create-database
create-database:
	@DB_NAME=$(or $(DB_NAME), $(shell read -p "Base de datos: " dbname; echo $$dbname)); \
	DB_USER=$(or $(DB_USER), $(shell read -p "Usuario: " user; echo $$user)); \
	docker-compose -f $(DOCKER_FILE) exec postgres psql -U $$DB_USER -W -c \
		"CREATE DATABASE "$$DB_NAME";"

.PHONY: privilegies-database
privilegies-database:
	@DB_NAME=$(or $(DB_NAME), $(shell read -p "Base de datos: " dbname; echo $$dbname)); \
	DB_USER=$(or $(DB_USER), $(shell read -p "Usuario: " user; echo $$user)); \
	docker-compose -f $(DOCKER_FILE) exec postgres psql -U $$DB_USER -W -c \
		"GRANT ALL PRIVILEGES ON DATABASE "$$DB_NAME" TO "$$DB_USER";"
