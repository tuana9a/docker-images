FROM ubuntu:24.04

RUN apt update && apt install -y \
    curl \
    wget \
    unzip \
    openssh-client

ENV ETCD_VER=v3.5.15

RUN mkdir -p /tmp/etcd-download \
    && curl -L https://storage.googleapis.com/etcd/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz \
    && tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download --strip-components=1 \
    && cp /tmp/etcd-download/etcd* /usr/local/bin/ \
    && /usr/local/bin/etcdctl version
