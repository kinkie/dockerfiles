# NOT WORKING! there are package conflicst when updating

ARG DISTRO=fedora
ARG VERSION=32
FROM ${DISTRO}:${VERSION}
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
#	yum clean all && yum swap fakesystemd systemd \
ADD local/* /usr/local/bin/
RUN \
	yum install -y \
		autoconf \
		automake \
		bzip2 \
		ccache \
		clang \
		cppunit \
		cppunit-devel \
		curl \
		db4-devel \
		ed \
		expat-devel \
		gcc-c++ \
		git \
		gnutls-devel \
		gnutls-utils \
		libatomic \
		libatomic-static \
		libcap-devel \
		libtdb-devel \
		libtool \
		libtool-ltdl-devel \
		libxml2-devel \
		make \
		nettle-devel \
		openldap-devel \
		openssl-devel \
		pam-devel \
		perl-Pod-MinimumVersion \
		pkgconf-pkg-config \
		redhat-lsb-core \
		xz \
	&& \
	yum clean all && \
	rm /etc/profile.d/ccache* && \
	groupadd -g 1000 jenkins && \
	useradd -u 1000 -g jenkins -m jenkins && \
	groupadd -g 1001 kinkie && \
	useradd -u 1001 -m -g kinkie kinkie && \
	true

USER jenkins
CMD ["/bin/bash", "-l"]

