FROM adityap174/poc:hadoop-base-2.0.4-hadoop-3.2.0-java8

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

ADD opt/zookeeper-3.4.7.tar.gz /opt/

RUN mv /opt/zookeeper-3.4.7 /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg
EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]
