FROM alpine:3.6

MAINTAINER autechgemz@gmail.com

RUN apk upgrade --update --available && \
    apk add --no-cache \
    runit \
    rsyslog \
    dnsmasq \
    bind-tools

COPY dnsmasq.d /etc/dnsmasq.d
COPY service /service

COPY rsyslog.conf /etc/rsyslog.conf
COPY dnsmasq.conf /etc/dnsmasq.conf

RUN chmod 755 /service/*/run

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["runsvdir", "-P", "/service/"]
