FROM alpine:3.3
MAINTAINER Damien DUPORTAL <dduportal@cloudbees.com>

RUN apk --update --no-cache add curl
VOLUME /app
WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY artifactory.config.xml /artifactory.config.xml

CMD ["/bin/sh","/entrypoint.sh"]
