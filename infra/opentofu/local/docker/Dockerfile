FROM debian:13

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Install systemd, SSH, and python (for Ansible)
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    openssh-server \
    python3 \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure SSH
RUN mkdir /var/run/sshd
# Allow root login with password for local testing simplicity
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Mask services that don't run well in docker
RUN systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount

# Standard systemd setup
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
