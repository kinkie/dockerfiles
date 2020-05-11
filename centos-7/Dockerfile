ARG DISTRO=centos
ARG VERSION=7
FROM ${DISTRO}:centos${VERSION}
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
	yum clean all && yum swap fakesystemd systemd && \
	yum install epel-release \
	yum update -y && \
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
		groff \
		java-1.8.0-openjdk-headless \
		libatomic \
		libcap-devel \
		linuxdoc-tools \
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
		po4a \
		redhat-lsb-core \
		translate-toolkit \
		which \
		xz \
	&& \
	yum install -y doxygen && \
	yum clean all && \
	groupadd -g 1000 jenkins && \
	useradd -u 1000 -g jenkins -m jenkins && \
	groupadd -g 1001 kinkie && \
	useradd -u 1001 -m -g kinkie kinkie && \
	rm -f /etc/profile.d/ccache* && \
	exit 0

USER jenkins
CMD ["/bin/bash"]

