FROM adityap174/poc:hadoop-base-dockercompatible-2.0.4-hadoop-3.2.0-java8

MAINTAINER Ivan Ermilov <ivan.s.ermilov@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

VOLUME /var/lib/docker

EXPOSE 8042

CMD ["/run.sh"]
