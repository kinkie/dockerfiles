FROM gentoo/portage:latest as portage
FROM gentoo/stage3-amd64:latest
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo
RUN \
	groupadd -g 1000 jenkins && \
	useradd -u 1000 -g jenkins -m jenkins && \
	groupadd -g 1001 kinkie && \
	useradd -u 1001 -m -g kinkie kinkie
RUN \
    emerge -q \
        dev-util/ccache \
        sys-devel/clang \
        dev-util/cppunit \
        sys-apps/ed \
        dev-vcs/git \
        sys-libs/libcap \
        sys-libs/tdb \
        net-nds/openldap \
        sys-apps/lsb-release \
        && \
    emerge -q --depclean && \
	true

USER jenkins
CMD ["/bin/bash", "-l"]

