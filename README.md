# Environment starter with default images.

This project provides an easy to get up and running with some of the major images used on my development process.

## Makefile variables
```
DOCKER_DIR := Directory where the docker-compose.yaml can be found.
```

## Kafka configuration
Runs with zookeeper and one broker. Suits local development needs.

```Shell
make docker
```

## Executing a producer.
To create a producer, just run the following command:

```Shell
make producer
```

## Executing a consumer
To run a kafka consumer on command line, run the following command:

```Shell
make consumer
```

## MongoDB
When executing

```Shell
make docker
```
you will be asked to provide a name to the a mongo database. User and password can be found in the init-mongo.js file, inside the docker directory.

```Shell
mongodb://<username>:<password>@localhost:27017/<database_name>
```
