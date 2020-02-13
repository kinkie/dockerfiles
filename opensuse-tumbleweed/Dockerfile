ARG DISTRO=opensuse
ARG REPO=${DISTRO}/tumbleweed
ARG VERSION=latest
FROM ${REPO}:${VERSION}
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
	zypper --non-interactive install \
		autoconf \
		automake \
		bzip2 \
		ccache \
		clang \
		cppunit-devel \
		curl \
		gcc-c++ \
		git \
		gnutls-devel \
		gnutls \
		gzip \
		java-1_8_0-openjdk-headless \
		libcap-devel \
		libexpat-devel \
		libltdl7 \
		libnettle-devel \
		libopenssl-devel \
		libtool \
		libxml2-devel \
		lsb-release \
		make \
		pkg-config \
		xz \
	&& \
	zypper --non-interactive clean && \
	useradd -m jenkins

