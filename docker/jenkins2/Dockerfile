FROM jenkins:2.3-alpine
MAINTAINER Damien DUPORTAL <dduportal@cloudbees.com>

USER root
RUN curl -L -o /tmp/docker-latest.tgz https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
  && tar xzf /tmp/docker-latest.tgz -C /tmp/ \
  && mv /tmp/docker/* /usr/bin/ \
  && chmod a+x /usr/bin/docker* \
  && rm -rf /tmp/docker* \
  && addgroup -g 50 docker \
  && addgroup jenkins docker \
  && addgroup root docker
USER jenkins
