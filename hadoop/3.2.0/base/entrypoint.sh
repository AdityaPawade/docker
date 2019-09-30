#!/bin/bash
set -x

# Set some sensible defaults
export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:8020}

function addXmlProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configureXml() {
    local path=$1
    local envPrefix=$2

    local var
    local value
    
    echo "Configuring $path"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/@/g; s/_/./g; s/@/_/g;'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addXmlProperty $path $name "$value"
    done
}

function addProperty() {
  local path=$1
  local value=$2

  echo $value >> $path
}

function configure() {
    local path=$1
    local envPrefix=$2

    local value

    echo "Configuring $path"

    for value in `printenv`; do
        if [[ $value == $envPrefix* ]]
        then
            local propertyValue=${value/"${envPrefix}_"}
            echo " - Setting $propertyValue"
            addProperty $path $propertyValue
        fi
    done
}

configureXml /etc/hadoop/core-site.xml CORE_CONF
configureXml /etc/hadoop/hdfs-site.xml HDFS_CONF
configureXml /etc/hadoop/yarn-site.xml YARN_CONF
configureXml /etc/hadoop/httpfs-site.xml HTTPFS_CONF
configureXml /etc/hadoop/kms-site.xml KMS_CONF
configureXml /etc/hadoop/mapred-site.xml MAPRED_CONF
configure /etc/hadoop/container-executor.cfg CONTAINEREXEC_CONF

if [ "$MULTIHOMED_NETWORK" = "1" ]; then
    echo "Configuring for multihomed network"

    # HDFS
    addXmlProperty /etc/hadoop/hdfs-site.xml dfs.namenode.rpc-bind-host 0.0.0.0
    addXmlProperty /etc/hadoop/hdfs-site.xml dfs.namenode.servicerpc-bind-host 0.0.0.0
    addXmlProperty /etc/hadoop/hdfs-site.xml dfs.namenode.http-bind-host 0.0.0.0
    addXmlProperty /etc/hadoop/hdfs-site.xml dfs.namenode.https-bind-host 0.0.0.0
    addXmlProperty /etc/hadoop/hdfs-site.xml dfs.client.use.datanode.hostname true
    addXmlProperty /etc/hadoop/hdfs-site.xml dfs.datanode.use.datanode.hostname true

    # YARN
    addXmlProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.bind-host 0.0.0.0
    addXmlProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
    addXmlProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
    addXmlProperty /etc/hadoop/yarn-site.xml yarn.timeline-service.bind-host 0.0.0.0

    # MAPRED
    addXmlProperty /etc/hadoop/mapred-site.xml yarn.nodemanager.bind-host 0.0.0.0
fi

if [ -n "$GANGLIA_HOST" ]; then
    mv /etc/hadoop/hadoop-metrics.properties /etc/hadoop/hadoop-metrics.properties.orig
    mv /etc/hadoop/hadoop-metrics2.properties /etc/hadoop/hadoop-metrics2.properties.orig

    for module in mapred jvm rpc ugi; do
        echo "$module.class=org.apache.hadoop.metrics.ganglia.GangliaContext31"
        echo "$module.period=10"
        echo "$module.servers=$GANGLIA_HOST:8649"
    done > /etc/hadoop/hadoop-metrics.properties
    
    for module in namenode datanode resourcemanager nodemanager mrappmaster jobhistoryserver; do
        echo "$module.sink.ganglia.class=org.apache.hadoop.metrics2.sink.ganglia.GangliaSink31"
        echo "$module.sink.ganglia.period=10"
        echo "$module.sink.ganglia.supportsparse=true"
        echo "$module.sink.ganglia.slope=jvm.metrics.gcCount=zero,jvm.metrics.memHeapUsedM=both"
        echo "$module.sink.ganglia.dmax=jvm.metrics.threadsBlocked=70,jvm.metrics.memHeapUsedM=40"
        echo "$module.sink.ganglia.servers=$GANGLIA_HOST:8649"
    done > /etc/hadoop/hadoop-metrics2.properties
fi

function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi
      
      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}

for i in ${SERVICE_PRECONDITION[@]}
do
    wait_for_it ${i}
done

exec $@
