# REF: https://github.com/patroni/patroni/blob/3e3a4e134699154eb6fa8fc63f5d54d8256f1536/kubernetes/Dockerfile

# postgres:16.11
FROM postgres@sha256:d4c3314b2dd74ff23cd6cd07e4d7e737cb6ef791c22a7cbd744cfbfb4815df72
LABEL maintainer="Nguyen Minh Tuan <tuana9a@gmail.com>"

RUN export DEBIAN_FRONTEND=noninteractive \
    && echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend \
    && apt-get update -y \
    && apt-cache depends patroni | sed -n -e 's/.* Depends: \(python3-.\+\)$/\1/p' \
            | grep -Ev '^python3-(sphinx|etcd|consul|kazoo|kubernetes)' \
            | xargs apt-get install -y vim-tiny curl jq locales git python3-pip python3-wheel \
    ## Make sure we have a en_US.UTF-8 locale available
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && pip3 install --break-system-packages setuptools \
    && pip3 install --break-system-packages 'git+https://github.com/patroni/patroni.git#egg=patroni[kubernetes]' \
    && PGHOME=/home/postgres \
    && mkdir -p $PGHOME \
    && chown postgres $PGHOME \
    && sed -i "s|/var/lib/postgresql.*|$PGHOME:/bin/bash|" /etc/passwd \
    # Set permissions for OpenShift
    && chmod 775 $PGHOME \
    && chmod 664 /etc/passwd \
    # Clean up
    && apt-get remove -y git python3-pip python3-wheel \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /root/.cache

COPY patroni.yml.tmpl /home/postgres/patroni.yml.tmpl
COPY entrypoint.sh /

EXPOSE 5432 8008
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 EDITOR=/usr/bin/editor
USER postgres
WORKDIR /home/postgres
CMD ["/bin/bash", "/entrypoint.sh"]