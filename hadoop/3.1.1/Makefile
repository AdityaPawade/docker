DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
tag := 2.0.0-hadoop-3.1.1-java8-adt

build:
	docker build -t bde2020/hadoop-base:$(tag) ./base
	docker build -t bde2020/hadoop-namenode:$(tag) ./namenode
	docker build -t bde2020/hadoop-datanode:$(tag) ./datanode
	docker build -t bde2020/hadoop-resourcemanager:$(tag) ./resourcemanager
	docker build -t bde2020/hadoop-nodemanager:$(tag) ./nodemanager
	docker build -t bde2020/hadoop-historyserver:$(tag) ./historyserver
	docker build -t bde2020/hadoop-submit:$(tag) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(tag) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(tag) hdfs dfs -copyFromLocal /opt/hadoop-3.1.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(tag) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(tag) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(tag) hdfs dfs -rm -r /input
