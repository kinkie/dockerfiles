# squid build image, plus wine development
FROM farm-ubuntu-focal:latest
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
USER root
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        libwine-dev \
    && \
    true

USER jenkins
CMD ["/bin/bash", "-l"]
