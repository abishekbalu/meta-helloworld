FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=nointeractive

#Install Dependencies and QEMU tools

RUN apt-get update && apt-get install -y \
    build-essential gcc g++ gawk wget git diffstat unzip texinfo \
    chrpath socat cpio python3 python3-pip python3-pexpect xz-utils \
    debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
    libsdl1.2-dev python3-subunit mesa-common-dev zstd lz4 file locales \
    sudo vim qemu-system-arm expect && \
    rm -rf /var/lib/apt/lists/*


# Locale Configurations
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8


# Create a new developer user as we cannot build a bitbake image as the root user
RUN useradd -m -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER developer
WORKDIR /home/developer

# Copy Automation Script into the container and make it executable
COPY --chown=developer:developer build_and_run.sh /home/developer/build_and_run.sh
RUN chmod +x /home/developer/build_and_run.sh

CMD ["/bin/bash", "/home/developer/build_and_run.sh"]
