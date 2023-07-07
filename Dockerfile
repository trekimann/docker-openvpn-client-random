FROM debian:latest

# Install openvpn
RUN apt-get update && \
    echo resolvconf resolvconf/linkify-resolvconf boolean false | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl openvpn tzdata iptables kmod iputils-ping resolvconf iproute2 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -s /bin/bash vpn

COPY /scripts /opt/scripts
RUN ls -al /opt/scripts

# Convert the line endings of the start.sh script
RUN apt-get update && apt-get install -y dos2unix
RUN dos2unix /opt/scripts/start.sh && chmod +x /opt/scripts/start.sh
RUN dos2unix /opt/scripts/start-server.sh && chmod +x /opt/scripts/start-server.sh

ENV INTERFACE="eth0"
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV DATA_DIR=/vpn
ENV RANDOM_VPN_CONFIG=true

VOLUME ["/vpn"]

ENTRYPOINT ["/opt/scripts/start.sh"]