# Using official image of debian wheezy as base
# If you want to create jessie, use debian:jessie
FROM orient/debian:wheezy

ENV DEBIAN_FRONTEND=noninteractive

# add oracle java repo to sources list
RUN echo "deb http://10.47.4.220/repos/oracle-java/9 /" | tee -a /etc/apt/sources.list.d/oracle-java.list

RUN apt-get update && \
    apt-get install --yes --allow-unauthenticated maven2 oracle-java8-jdk infra-cli && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/jdk-8-oracle-x64

RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
  update-alternatives --install "/usr/bin/javaws" "javaws" "${JAVA_HOME}/bin/javaws" 1 && \
  update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
  update-alternatives --set java "${JAVA_HOME}/bin/java" && \
  update-alternatives --set javaws "${JAVA_HOME}/bin/javaws" && \
  update-alternatives --set javac "${JAVA_HOME}/bin/javac"

RUN env | grep _ >> /etc/environment
