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