#!/bin/bash
set -x

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver
