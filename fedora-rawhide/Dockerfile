ARG DISTRO=fedora
ARG VERSION=rawhide
ARG RELEASE=30
FROM ${DISTRO}:${VERSION}
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
#	dnf clean all && yum swap fakesystemd systemd \
#	dnf -y update --releasever=30 fedora-repos\* fedora-release dnf && \
#	rpm --import https://src.fedoraproject.org/rpms/fedora-repos/raw/master/f/RPM-GPG-KEY-fedora-32-primary && \
#		libdb4-devel \
ADD local/* /usr/local/bin/
RUN \
	dnf update -y --nogpg && \
	dnf install -y --nogpg \
		autoconf \
		automake \
		bzip2 \
		ccache \
		clang \
		cppunit \
		cppunit-devel \
		curl \
		ed \
		expat-devel \
		gcc-c++ \
		git \
		gnutls-devel \
		gnutls-utils \
		libatomic \
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
		redhat-lsb-core \
		xz \
	&& \
	yum clean all && \
    true
RUN \
	groupadd -g 1000 jenkins && \
	useradd -u 1000 -g jenkins -m jenkins && \
	groupadd -g 1001 kinkie && \
	useradd -u 1001 -m -g kinkie kinkie && \
	true

USER jenkins
CMD ["/bin/bash", "-l"]

