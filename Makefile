ROOT_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOCKER_DIR := $(ROOT_DIR)/docker
DOCKER_FILE := $(DOCKER_DIR)/docker-compose.yml

.DEFAULT_TARGET: docker

.PHONY: docker
docker:
	docker-compose -f $(DOCKER_FILE) --project-directory $(DOCKER_DIR) up -d

.PHONY: docker-stop
docker-stop:
	docker-compose -f $(DOCKER_FILE) down -v

.PHONY: producer
producer:
	@TOPIC=$(or $(TOPIC), $(shell read -p "TOPIC: " topic; echo $$topic)); \
	docker-compose -f $(DOCKER_FILE) exec kafka \
		kafka-console-producer --broker-list localhost:9092 --topic $$TOPIC

.PHONY: consumer
consumer:
	@TOPIC=$(or $(TOPIC), $(shell read -p "TOPIC: " topic; echo $$topic)); \
	docker-compose -f $(DOCKER_FILE) exec kafka \
		kafka-console-consumer --bootstrap-server localhost:9092 --topic $$TOPIC