############################################################
# Dockerfile to run an OrientDB (Graph) Container
############################################################

FROM orient/java:8-wheezy

MAINTAINER OrientDB LTD (info@orientdb.com)

# Override the orientdb download location with e.g.:
#   docker build -t mine --build-arg ORIENTDB_DOWNLOAD_SERVER=http://repo1.maven.org/maven2/com/orientechnologies/ .
#ARG ORIENTDB_DOWNLOAD_SERVER

#ENV ORIENTDB_VERSION 3.0.10
#ENV ORIENTDB_DOWNLOAD_MD5 e6afdbe678b01a82e03601e58ff46bc7
#ENV ORIENTDB_DOWNLOAD_SHA1 9be4cf0e052d5c0fd48665cda3e13ab378ed6994

#ENV ORIENTDB_DOWNLOAD_URL ${ORIENTDB_DOWNLOAD_SERVER:-http://central.maven.org/maven2/com/orientechnologies}/orientdb-community/$ORIENTDB_VERSION/orientdb-community-$ORIENTDB_VERSION.tar.gz


RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

#download distribution tar, untar and delete databases
RUN mkdir /orientdb && \
  wget  https://s3.us-east-2.amazonaws.com/orientdb3/releases/3.0.8/orientdb-3.0.8.tar.gz -O orientdb-community-3.0.8.tar.gz \
  && tar -xvzf orientdb-community-3.0.8.tar.gz -C /orientdb --strip-components=1 \
  && rm -rf /orientdb/databases/*


ENV PATH /orientdb/bin:$PATH
ENV ORIENTDB_ROOT_PASSWORD root

VOLUME ["/orientdb/backup", "/orientdb/databases", "/orientdb/config"]

WORKDIR /orientdb

#OrientDb binary
EXPOSE 2424

#OrientDb http
EXPOSE 2480

# Default command start the server
CMD ["dserver.sh"]