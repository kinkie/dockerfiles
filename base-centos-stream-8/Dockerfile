#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"
FROM scratch
ADD centos-8-stream-root.tar.gz /
LABEL \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="CentOS Base Image" \
    org.label-schema.vendor="Squid Web Cache" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20201204"
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
CMD ["/bin/bash"]
