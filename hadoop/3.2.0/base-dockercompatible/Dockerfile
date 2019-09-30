FROM adityap174/poc:hadoop-base-2.0.4-hadoop-3.2.0-java8

############
## Docker ##
############
ARG DOCKER_CHANNEL=stable
ARG DOCKER_VERSION=18.06.3

RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   ${DOCKER_CHANNEL}"
RUN apt-get update && apt-cache madison docker-ce && apt-get install -y --no-install-recommends docker-ce=${DOCKER_VERSION}~ce~3-0~debian && \
  docker -v && \
  dockerd -v

####################
## Docker Compose ##
####################
ARG DOCKER_COMPOSE_VERSION=1.18.0
RUN curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose

#################
## DIND Script ##
#################
ARG DIND_COMMIT=52379fa76dee07ca038624d639d9e14f4fb719ff
ENV DOCKER_EXTRA_OPTS '--storage-driver=overlay'
RUN curl -fL -o /usr/local/bin/dind "https://raw.githubusercontent.com/moby/moby/${DIND_COMMIT}/hack/dind" && \
	chmod +x /usr/local/bin/dind


################
## Entrypoint ##
################
ADD start_docker.sh /usr/local/bin/start_docker
RUN chmod +x /usr/local/bin/start_docker

VOLUME /var/lib/docker
EXPOSE 2375

CMD ["start_docker"]