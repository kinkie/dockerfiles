# squid build image, plus wine development
FROM squidcache/buildfarm-ubuntu-focal:stable
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
USER root
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        mingw-w64 \
        wine \
        wine-binfmt \
    && \
    true

USER jenkins
CMD ["/bin/bash", "-l"]
