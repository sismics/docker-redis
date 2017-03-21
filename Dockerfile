#
# Dockerfile for Redis
#

FROM ubuntu:yakkety
MAINTAINER Jean-Marc Tremeaux <jm.tremeaux@sismics.com>

ENV REDIS_USER=redis
ENV REDIS_DATA_DIR=/var/lib/redis
ENV REDIS_LOG_DIR=/var/log/redis

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server \
 && rm -rf /var/lib/apt/lists/*
RUN sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf \
 && sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocketperm 755/unixsocketperm 777/' -i /etc/redis/redis.conf \
 && sed '/^logfile/d' -i /etc/redis/redis.conf

COPY opt /opt
RUN chmod 755 /opt/bin/*.sh

EXPOSE 6379/tcp
CMD ["/opt/bin/entrypoint.sh"]
