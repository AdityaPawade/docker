# Using official image of debian wheezy as base
FROM debian:wheezy

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://10.85.43.6/debian wheezy main" | tee -a /etc/apt/sources.list
RUN echo "deb http://10.85.43.6/debian wheezy-backports main" | tee -a /etc/apt/sources.list.d/wheezy.list

# Install basic utilities
RUN apt-get update && \
    apt-get install -y --force-yes --allow-unauthenticated adduser ca-certificates curl net-tools sudo \
         vim wget netcat && \
    rm -rf /var/lib/apt/lists/*

COPY wait-for-it.sh /usr/bin/wait-for-it

RUN chmod 755 /usr/bin/wait-for-it

WORKDIR /home/arrangodb
