FROM squidcache/buildfarm-ubuntu-noble:latest
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
ADD cov-analysis-linux64-2023.12.2.tar.gz /usr/local/
ADD coverity.sh /etc/profile.d/
USER root
RUN \
    ln -vs /usr/local/cov*/bin/* /usr/local/bin && \
	exit 0

USER jenkins
CMD ["/bin/bash"]
