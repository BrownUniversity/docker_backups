#!/bin/bash
source /opt/local/docker_backups/config.conf

# Prep backup_dir
mkdir -p ${BACKUP_DIR} >/dev/null 2>&1

# Docker DTR info
DTR_ID=$(docker ps --format '{{.Names}}' -f name=dtr-rethink | cut -f 3 -d '-')
DTR_VERSION=$(docker container inspect $(docker container ps -f name=dtr-registry -q) | grep -m1 -Po '(?<=DTR_VERSION=)\d.\d.\d')
REPLICA_ID=$(docker ps --format '{{.Names}}' -f name=dtr-rethink | cut -f 3 -d '-')

# Backup image content
tar -cf ${BACKUP_DIR}/dtr-image-backup-${DATE}.tar \
/var/lib/docker/volumes/dtr-registry-${DTR_ID}

# Backup metadata
docker run --log-driver none -i --rm \
  --env UCP_PASSWORD=${UCP_PASSWORD} \
  docker/dtr:${DTR_VERSION} backup \
  --ucp-username ${UCP_ADMIN} \
  --ucp-url ${UCP_URL} \
  --ucp-ca "$(curl https://${UCP_URL}/ca)" \
  --existing-replica-id ${REPLICA_ID} > ${BACKUP_DIR}/dtr-metadata-${DTR_VERSION}-backup.tar
