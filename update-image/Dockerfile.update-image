
ARG distro=@DISTRO@
FROM squidcache/buildfarm-${distro}:stable
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/

USER root
RUN \
    if [ -n "$(which apt-get)" ]; then \
        apt-get -y update && \
        apt-get -y upgrade --no-install-recommends -y && \
        apt-get autoremove -y && \
        apt-get clean -y && \
        true ; \
    elif [ -n "$(which dnf)" ]; then \
        dnf dnf -y upgrade && \
        true ; \
    else \
        false ;\
    fi

USER jenkins
CMD ["/bin/bash", "-l"]
