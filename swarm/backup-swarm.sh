#!/bin/bash
source /opt/local/docker_backups/config.conf

# Prep backup_dir
mkdir -p ${BACKUP_DIR} >/dev/null 2>&1

# Swarm info
ENGINE=$(docker version -f '{{.Server.Version}}')

# Exclude the leader? Not an issue yet

# Stop manager
systemctl stop docker

# Backup /var/lib/docker/swarm
tar cvzf "${BACKUP_DIR}/swarm-${ENGINE}-$(hostname -s)-${DATE}.tgz" /var/lib/docker/swarm/

# Restart manager
systemctl start docker