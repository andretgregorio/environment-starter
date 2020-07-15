ROOT_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOCKER_DIR := $(ROOT_DIR)/docker
DOCKER_FILE := $(DOCKER_DIR)/docker-compose.yml

.DEFAULT_TARGET: docker

.PHONY: prepare-environment
prepare-environment:
	@DB_USER=$(or $(DB_USER), $(shell read -p "Postgres User: " user; echo "DB_USER="$$user)); \
	DB_PASS=$(or $(DB_PASS), $(shell read -p "Postgres Pass: " pass; echo "DB_PASS="$$pass)); \
	MONGO_DB_DATABASE=$(or $(MONGO_DB_DATABASE), $(shell read -p "MongoDB Database: " mongo_database; echo "MONGO_DB_DATABASE="$$mongo_database)); \
	printf "$$DB_USER\n$$DB_PASS\n$$MONGO_DB_DATABASE\n" > docker/.env

.PHONY: docker
docker: prepare-environment
	@echo "Creando las instancias de docker para PostgreSQL, MongoDB, Redis y Kafka"
	@docker-compose -f $(DOCKER_FILE) --project-directory $(DOCKER_DIR) up -d

.PHONY: docker-down
docker-down:
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
		redis-cli GET $$KEY

.PHONY: redis-get-keys
redis-get-keys:
	@KEY=$(or $(KEY), $(shell read -p "Inicio de clave: " key; echo $$key)); \
	docker-compose -f $(DOCKER_FILE) exec redis \
		redis-cli KEYS "$$KEY*"

.PHONY: redis-set
redis-set:
	@KEY=$(or $(KEY), $(shell read -p "Clave: " key; echo $$key)); \
	VALUE=$(or $(VALUE), $(shell read -p "Valor: " value; echo $$value)); \
	docker-compose -f $(DOCKER_FILE) exec redis \
		redis-cli SET "$$KEY" $$VALUE

.PHONY: redis-delete
redis-delete:
	@KEY=$(or $(KEY), $(shell read -p "Clave: " key; echo $$key)); \
	docker-compose -f $(DOCKER_FILE) exec redis \
		redis-cli DEL "$$KEY"

.PHONY: redis-flush-all
redis-flush-all:
	@echo "Removiendo todo el cache..."; \
	docker-compose -f $(DOCKER_FILE) exec redis \
		redis-cli FLUSHALL

.PHONY: create-database
create-database:
	@DB_NAME=$(or $(DB_NAME), $(shell read -p "Base de datos: " dbname; echo $$dbname)); \
	DB_USER=$(or $(DB_USER), $(shell read -p "Usuario: " user; echo $$user)); \
	docker-compose -f $(DOCKER_FILE) exec postgres psql -U $$DB_USER -W -c \
		"CREATE DATABASE "$$DB_NAME";"

.PHONY: drop-database
drop-database:
	@DB_NAME=$(or $(DB_NAME), $(shell read -p "Base de datos: " dbname; echo $$dbname)); \
	DB_USER=$(or $(DB_USER), $(shell read -p "Usuario: " user; echo $$user)); \
	docker-compose -f $(DOCKER_FILE) exec postgres psql -U $$DB_USER -W -c \
		"DROP DATABASE "$$DB_NAME";"

.PHONY: privileges-database
privileges-database:
	@DB_NAME=$(or $(DB_NAME), $(shell read -p "Base de datos: " dbname; echo $$dbname)); \
	DB_USER=$(or $(DB_USER), $(shell read -p "Usuario: " user; echo $$user)); \
	docker-compose -f $(DOCKER_FILE) exec postgres psql -U $$DB_USER -W -c \
		"GRANT ALL PRIVILEGES ON DATABASE "$$DB_NAME" TO "$$DB_USER";"
