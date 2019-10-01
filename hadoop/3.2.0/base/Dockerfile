FROM debian:9

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      procps vim less \
    && rm -rf /var/lib/apt/lists/*
      
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

#RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS

#RUN gpg --import KEYS

ENV HADOOP_VERSION 3.2.0
#ENV HADOOP_URL https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

ADD opt/hadoop-base.tar.gz /opt/

RUN chown -R root:root /opt/hadoop-$HADOOP_VERSION && \
    chmod 744 /opt/hadoop-3.2.0/bin/container-executor && \
    chmod u+s /opt/hadoop-3.2.0/bin/container-executor

ADD opt/hadoop-$HADOOP_VERSION/share/hadoop/client.tar.gz /opt/hadoop-$HADOOP_VERSION/share/hadoop
ADD opt/hadoop-$HADOOP_VERSION/share/hadoop/common.tar.gz /opt/hadoop-$HADOOP_VERSION/share/hadoop
ADD opt/hadoop-$HADOOP_VERSION/share/hadoop/hdfs.tar.gz /opt/hadoop-$HADOOP_VERSION/share/hadoop
ADD opt/hadoop-$HADOOP_VERSION/share/hadoop/mapreduce.tar.gz /opt/hadoop-$HADOOP_VERSION/share/hadoop
ADD opt/hadoop-$HADOOP_VERSION/share/hadoop/tools.tar.gz /opt/hadoop-$HADOOP_VERSION/share/hadoop
ADD opt/hadoop-$HADOOP_VERSION/share/hadoop/yarn.tar.gz /opt/hadoop-$HADOOP_VERSION/share/hadoop

#RUN set -x \
#    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
#    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
#    && gpg --verify /tmp/hadoop.tar.gz.asc \
#    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
#    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

ADD container-executor.cfg /etc/hadoop/container-executor.cfg

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH $HADOOP_HOME/bin/:$PATH

RUN adduser --disabled-password --gecos '' yarnuser

ADD entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
