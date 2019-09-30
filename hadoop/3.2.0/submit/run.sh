#!/bin/bash
set -x

$HADOOP_HOME/bin/hadoop jar $JAR_FILEPATH $CLASS_TO_RUN $PARAMS 
