#PLATFORMS amd64 arm64

# EOL Jul 2026

FROM squidcache/buildfarm-ubuntu-questing:latest AS base

LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/ubuntu-gdb"
LABEL description="Ubuntu Questing userland for interactive development"

USER root
RUN \
  apt-get update && \
  apt-get upgrade -y apt && \
  apt-get update && \
  apt-get upgrade --no-install-recommends -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gdb \
    vim \
  && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  true

USER jenkins
CMD ["/bin/bash", "-l"]
