#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

FROM farm-centos-8
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
USER root
RUN \
    dnf -y install centos-release-stream && \
    dnf -y swap centos-{linux,stream}-repos && \
    dnf -y distro-sync && \
    dnf -y update && \
    dnf -y upgrade && \
	dnf clean all && \
	true

USER jenkins
CMD ["/bin/bash", "-l"]
