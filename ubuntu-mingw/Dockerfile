# squid build image, plus wine development
FROM squidcache/buildfarm-ubuntu-jammy:latest
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
USER root
RUN \
  apt -y update && \
  apt -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    mingw-w64 \
    wine-binfmt \
  && \
  true

USER jenkins
CMD ["/bin/bash", "-l"]
