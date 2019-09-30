#!/bin/bash
set -x

export DOCKER_EXTRA_OPTS="--exec-opt native.cgroupdriver=cgroupfs"
nohup start_docker > /tmp/start_docker.log 2>&1 &

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager
