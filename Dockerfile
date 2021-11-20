FROM ubuntu:focal
ENV LANG=C.UTF-8
ENV LANG_ALL C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
ARG DNSMASQ_VERSION=2.86
COPY sources.list /etc/apt/sources.list
RUN apt-get -y update \
 && apt-get -y install --no-install-recommends -y \
    tzdata \
    runit \
    ca-certificates \
    dnsutils \
    build-essential \
    automake \
    autoconf \
    libtool \
    tar \
    curl \
    rsyslog \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && curl -O https://thekelleys.org.uk/dnsmasq/dnsmasq-${DNSMASQ_VERSION}.tar.xz \
 && tar Jxvf /dnsmasq-${DNSMASQ_VERSION}.tar.xz \
 && cd /dnsmasq-${DNSMASQ_VERSION} \
 && make \
 && make install \
 && rm -rf /dnsmasq-${DNSMASQ_VERSION} \
 && rm -f /dnsmasq-${DNSMASQ_VERSION}.tar.xz \
 && mkdir -p /etc/dnsmasq.d \
 && apt-get -y purge \
    build-essential \
    automake \
    autoconf \
    libtool \
    curl \
 && apt autoremove -y \
 && apt autopurge -y \
 && apt autoclean -y
COPY resolv_dnsmasq.conf /etc/resolv_dnsmasq.conf
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY rsyslog.conf /etc/rsyslog.conf
COPY services /services
RUN chmod +x /services/*/run
EXPOSE 53/tcp 53/udp
ENTRYPOINT [ "runsvdir", "-P", "/services/" ]
