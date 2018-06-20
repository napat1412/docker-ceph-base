# CEPH BASE IMAGE
# CEPH VERSION: Jewel
# CEPH VERSION DETAIL: 0.94.x

FROM centos:7
MAINTAINER Napat Chunagchunsong "napat.chu@gmail.com"

ENV CEPH_VERSION luminous
ENV CONFD_VERSION 0.10.0
ENV ETCD_VERSION v3.3.5

# Install Ceph
RUN rpm --import 'https://download.ceph.com/keys/release.asc'
RUN rpm -Uvh http://download.ceph.com/rpm-${CEPH_VERSION}/el7/noarch/ceph-release-1-1.el7.noarch.rpm
RUN yum install -y epel-release && yum clean all
ARG PACKAGES="unzip ceph-mon ceph-osd ceph-mds ceph-base ceph-common ceph-radosgw rbd-mirror device-mapper sharutils etcd kubernetes-client e2fsprogs wget"
RUN yum install -y $PACKAGES && rpm -q $PACKAGES && yum clean all

# Install confd
ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd && mkdir -p /etc/confd/conf.d && mkdir -p /etc/confd/templates

# Download forego
RUN wget -O /forego.tgz 'https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz' && \
  cd /usr/local/bin && tar xfz /forego.tgz && chmod +x /usr/local/bin/forego && rm /forego.tgz
# Download etcdctl
RUN wget -O /etcd.tgz "https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz" && \
  cd /tmp && tar xfz /etcd.tgz && cp etcd-${ETCD_VERSION}-linux-amd64/etcd* /usr/local/bin/ && chmod +x /usr/local/bin/etcd* && rm -rf etcd-${ETCD_VERSION}-linux-amd64 && rm /etcd.tgz

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh","/entrypoint.sh"]
