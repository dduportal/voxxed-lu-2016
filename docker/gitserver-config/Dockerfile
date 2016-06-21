FROM alpine:3.3
MAINTAINER Damien DUPORTAL <dduportal@cloudbees.com>

# This container will just run 1 time, to auto-configure the applications
RUN apk --update --no-cache add \
  curl \
  git \
  openssh-client

COPY entrypoint.sh /entrypoint.sh
CMD ["/bin/sh","/entrypoint.sh"]
