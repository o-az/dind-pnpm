FROM ubuntu:latest

ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NOWARNINGS="yes"
ARG DEBCONF_TERSE="yes"
ARG LANG="C.UTF-8"
ARG CURL_OPTIONS="--silent --show-error --location --fail --retry 3 --tlsv1.2 --proto =https"

RUN apt-get update --yes && \
  apt-get --yes install --no-install-recommends \
  apt-utils \
  dialog 2>&1 \
  lsb-release \
  ca-certificates \
  apt-transport-https \
  software-properties-common \
  git \
  lxc \
  sudo \
  curl \
  wget \
  gnupg \
  procps \
  systemd \
  iptables \
  #
  # leveldb requirements
  g++ \
  make \
  libsnappy-dev && \
  ln -sf /usr/bin/python3 /usr/bin/python && \
  rm -rf /var/lib/apt/lists/*

# Install Docker (comes with compose plugin)
RUN curl ${CURL_OPTIONS} https://get.docker.com | sudo bash && \
  #
  # Install dind hack script
  sudo curl ${CURL_OPTIONS} "https://raw.githubusercontent.com/moby/moby/master/hack/dind" \
  --output /usr/local/bin/dind && \
  chmod a+x /usr/local/bin/dind

# Install pnpm and Node.js LTS
RUN sudo curl ${CURL_OPTIONS} https://get.pnpm.io/install.sh | bash - && \
  #
  # Setup and source root bashrc to get pnpm in PATH
  . ~/.bashrc && \
  #
  # Install Node.js LTS
  pnpm env use --global lts && \
  #
  # leveldb requirements
  pnpm add --global node-gyp node-gyp-build

# Install Doppler CLI
RUN curl ${CURL_OPTIONS} https://cli.doppler.com/install.sh | sudo bash

VOLUME /var/lib/docker

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]