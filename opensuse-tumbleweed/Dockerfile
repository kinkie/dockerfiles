ARG DISTRO=opensuse
ARG REPO=${DISTRO}/tumbleweed
ARG VERSION=latest
FROM ${REPO}:${VERSION}
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
	zypper --non-interactive install --no-confirm --auto-agree-with-licenses --force-resolution \
		autoconf \
		automake \
		bzip2 \
		ccache \
		clang \
		cppunit-devel \
		curl \
		diffutils \
		ed \
		find \
		gawk \
		gcc-c++ \
		git \
		gnutls-devel \
		gnutls \
		gzip \
		libcap-devel \
		libexpat-devel \
		libltdl7 \
		libnettle-devel \
		libopenssl-devel \
		libtool \
		libxml2-devel \
		make \
		pkg-config \
		util-linux \
		which \
		xz \
	&& \
	zypper --non-interactive clean && \
    groupadd -g 3128 jenk && \
    useradd -u 3128 -g jenk -m jenk && \
	useradd -m jenkins && \
	useradd -m kinkie

# old pacakges
#		java-1_8_0-openjdk-headless \
