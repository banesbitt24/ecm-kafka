FROM centos:7

VOLUME /opt/sc

ENV SC_VER=5.17.0-el7
ARG S6_OVERLAY_VERSION=2.2.0.1

WORKDIR /tmp

RUN rpm --import https://static.tenable.com/marketing/RPM-GPG-KEY-Tenable

COPY yum.repo /etc/yum.repos.d/Tenable.repo

RUN yum -y update \
 && yum install -y wget java-1.8.0-openjdk \
 && wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz \
 && tar xzf s6-overlay-amd64.tar.gz -C / --exclude="./bin" \
 && tar xzf s6-overlay-amd64.tar.gz -C /usr ./bin \
 && yum -y clean all

FROM tiangolo/docker-with-compose

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]