FROM alpine:latest

RUN apk upgrade --update --available && \
    apk add --no-cache \
    runit \
    rsyslog \
    dnsmasq \
    bind-tools

COPY dnsmasq.d /etc/dnsmasq.d
COPY services /services

COPY rsyslog.conf /etc/rsyslog.conf
COPY dnsmasq.conf /etc/dnsmasq.conf

RUN chmod 755 /services/*/run

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["runsvdir", "-P", "/services/"]
