# squid build image, plus wine development
FROM squidcache/buildfarm-x86_64-ubuntu-focal:stable
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
USER root
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        mingw-w64 \
    && \
    true

USER jenkins
CMD ["/bin/bash", "-l"]
