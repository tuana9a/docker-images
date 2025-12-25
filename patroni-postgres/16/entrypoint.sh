#!/bin/bash

set -euo pipefail

if [[ $UID -ge 10000 ]]; then
    GID=$(id -g)
    sed -e "s/^postgres:x:[^:]*:[^:]*:/postgres:x:$UID:$GID:/" /etc/passwd > /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
fi

patroni_yml="/home/postgres/patroni.yml"
patroni_yml_tmpl="/home/postgres/patroni.yml.tmpl"

if [ ! -f "$patroni_yml" ]; then
    echo "File $patroni_yml not found. Copying from template..."    
    cp "$patroni_yml_tmpl" "$patroni_yml"
fi

sed -i "s|\${PATRONI_REPLICATION_USERNAME}|$PATRONI_REPLICATION_USERNAME|g" "$patroni_yml"
sed -i "s|\${PATRONI_REPLICATION_PASSWORD}|$PATRONI_REPLICATION_PASSWORD|g" "$patroni_yml"
sed -i "s|\${PATRONI_SUPERUSER_PASSWORD}|$PATRONI_SUPERUSER_PASSWORD|g" "$patroni_yml"
sed -i "s|\${PATRONI_KUBERNETES_POD_IP}|$PATRONI_KUBERNETES_POD_IP|g" "$patroni_yml"

unset PATRONI_SUPERUSER_PASSWORD PATRONI_REPLICATION_PASSWORD

exec /usr/bin/python3 /usr/local/bin/patroni $patroni_yml