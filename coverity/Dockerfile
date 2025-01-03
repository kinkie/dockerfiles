#PLATFORMS amd64
# to get coverity binary:
# export TOKEN=secret_token
# export PROJECT=Squid
# wget -q https://scan.coverity.com/download/cxx/linux64 \
#    --post-data "token=$TOKEN&project=$PROJECT" -O cov-analysis-linux64.tar.gz


FROM squidcache/buildfarm-ubuntu-noble:latest
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/coverity"
LABEL description="Userland needed to use Coverity Scan on Squid"

ADD cov-analysis-linux64.tar.gz /usr/local
ADD coverity.sh /etc/profile.d/
USER root
RUN \
    ln -vs /usr/local/cov*/bin/* /usr/local/bin && \
	exit 0

USER jenkins
CMD ["/bin/bash"]
