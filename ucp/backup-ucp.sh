#!/bin/bash
source /opt/local/docker_backups/config.conf

# Prep backup_dir
mkdir -p ${BACKUP_DIR} >/dev/null 2>&1

# Get instance ID
UCP_INSTANCE=$(docker info 2>/dev/null |grep ClusterID|awk '{print $NF}')
UCP_VERSION=$(docker container inspect $(docker container ps -f name=ucp-controller -q) |  grep -m1 -Po '(?<="com\.docker\.ucp\.version": )"\d.\d.\d"' | tr -d '"' )

# Create a backup, encrypt it, and store it on /tmp/backup.tar
docker container run \
  --log-driver none --rm \
  --interactive \
  --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  mirantis/ucp:${UCP_VERSION} backup \
  --no-passphrase   > ${BACKUP_DIR}/ucp-backup-${DATE}.tar