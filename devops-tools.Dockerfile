FROM ubuntu:24.04

RUN apt update && apt install -y \
    curl \
    wget \
    unzip

RUN mkdir -p /tools/bin

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz \
    && tar -xf google-cloud-cli-linux-x86_64.tar.gz -C /tools \
    && /tools/google-cloud-sdk/install.sh \
    && rm google-cloud-cli-linux-x86_64.tar.gz

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install -i /tools/aws-cli -b /tools/bin \
    && rm awscliv2.zip

ENV ETCD_VER=v3.5.15

RUN mkdir -p /tmp/etcd-download \
    && curl -L https://storage.googleapis.com/etcd/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz \
    && tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download --strip-components=1 \
    && cp /tmp/etcd-download/etcd* /tools/bin/ \
    && /tools/bin/etcdctl version \
    && rm -r /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz /tmp/etcd-download

ENV TERRAFORM_VERSION=1.7.1

RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /tools/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && /tools/bin/terraform -v
