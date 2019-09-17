#!/bin/bash
set -x

$HADOOP_HOME/bin/hdfs dfs -mkdir -p /input/
$HADOOP_HOME/bin/hdfs dfs -copyFromLocal /opt/hadoop-3.1.1/README.txt /input/
$HADOOP_HOME/bin/hadoop jar $JAR_FILEPATH $CLASS_TO_RUN $PARAMS 
$HADOOP_HOME/bin/hdfs dfs -cat /output/*
$HADOOP_HOME/bin/hdfs dfs -rm -r /output
$HADOOP_HOME/bin/hdfs dfs -rm -r /input