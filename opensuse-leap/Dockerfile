ARG DISTRO=opensuse/leap
ARG VERSION=latest
FROM ${DISTRO}:${VERSION}
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
		ed \
		gcc8-c++ \
		git \
		gnutls-devel \
		gnutls \
		gzip \
		icecream \
		libcap-devel \
		libexpat-devel \
		libltdl7 \
		libnettle-devel \
		libopenssl-devel \
		libtool \
		libxml2-devel \
		make \
		pkg-config \
		which \
		xz \
	&& \
	zypper --non-interactive clean && \
	useradd -m jenkins && \
	useradd -m kinkie
RUN \
	update-alternatives --install /usr/bin/g++ c++ /usr/bin/g++-8 20 && \
	update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-8 20 && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 20 && \
	true
USER jenkins
CMD ["/bin/bash", "-l"]
