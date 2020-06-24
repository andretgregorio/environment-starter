# Kafka Docker by CPGOPS

El proposito de este proyecto de crear las configuraciones de docker necesarias para crear las instancias de Kafka para usarse en un entorno local.

## Descripción de las variables del Makefile
Se describen a continuación las variables del Makefile

```
DOCKER_DIR := Directorio donde se encuentran los docker-compose.yml
```

## Configuración de Kafka
La configuración por defecto funciona muy bien para un zookeeper y un broker suficiente para correr pruebas en local.

```Shell
make docker
```

## ¿Cómo correr un productor?
Para correr un productor de kafka debes correr en la consola el siguiente comando y ingresar le topico

```Shell
make producer
```

## ¿Cómo correr un consumidor?
Para correr un consumidor de kafka debes correr en la consola el siguiente comando y ingresar le topico

```Shell
make consumer
```

## Creacion de base de datos en mongo
Al correr el comando

```Shell
make docker
```
se solicitara una nombre para inicializar una base de datos en MongoDb. El usuario y contraseña se encuentran en el archivo init-mongo.js dentro de la carpeta docker. De esta manera para conectarse a la base de datos de forma local a traves del path de mongodb:

```Shell
mongodb://<username>:<password>@localhost:27017/<database_name>
```