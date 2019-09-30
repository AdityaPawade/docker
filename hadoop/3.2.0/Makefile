DOCKER_NETWORK = hadoop-poc-network
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
tag := 2.0.4-hadoop-3.2.0-java8

build:
	docker build -t adityap174/poc:hadoop-base-$(tag) ./base
	docker build -t adityap174/poc:hadoop-base-dockercompatible-$(tag) ./base-dockercompatible
	docker build -t adityap174/poc:hadoop-namenode-$(tag) ./namenode
	docker build -t adityap174/poc:hadoop-datanode-$(tag) ./datanode
	docker build -t adityap174/poc:hadoop-resourcemanager-$(tag) ./resourcemanager
	docker build -t adityap174/poc:hadoop-nodemanager-$(tag) ./nodemanager
	docker build -t adityap174/poc:hadoop-historyserver-$(tag) ./historyserver
	docker build -t adityap174/poc:zookeeper-$(tag) ./zookeeper
	docker build -t adityap174/poc:hadoop-submit-$(tag) ./submit

wordcount:
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} adityap174/poc:hadoop-base-$(tag) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} adityap174/poc:hadoop-base-$(tag) hdfs dfs -copyFromLocal /opt/hadoop-3.2.0/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} adityap174/poc:hadoop-submit-$(tag)
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} adityap174/poc:hadoop-base-$(tag) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} adityap174/poc:hadoop-base-$(tag) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} adityap174/poc:hadoop-base-$(tag) hdfs dfs -rm -r /input
