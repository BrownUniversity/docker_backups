#!/bin/bash
source /opt/local/dckr-backup/config.conf

# Prep backup_dir
mkdir -p ${BACKUP_DIR} >/dev/null 2>&1

# Get instance ID
UCP_INSTANCE=$(docker info 2>/dev/null |grep ClusterID|awk '{print $NF}')
UCP_VERSION=$(docker container inspect $(docker container ps -f name=ucp-agent -q) | grep -m1 -Po '(?<=IMAGE_VERSION=)\d.\d.\d')

# Create a backup, encrypt it, and store it on /tmp/backup.tar
docker container run \
  --log-driver none --rm \
  --interactive \
  --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:${UCP_VERSION} backup \
  --no-passphrase \
  --id ${UCP_INSTANCE}  > ${BACKUP_DIR}/ucp-backup-${DATE}.tar