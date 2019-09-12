# docker_backups

These are scripts that will backup the UCP, DTR, and the Swarm.

## Files and Descriptions

* config.conf - Common variables and instance configurations
* backup-swarm.sh - Stop docker and backup swarm, Runs on UCP
* backup-ucp.sh - Backup UCP config with no passphase, Runs on UCP
* backup-dtr.sh - Backup image content and DTR configs, Runs on DTR
* intentory - docker cluster ansible inventory file
* playbooks - ansible playbooks for backups


## Order of backups

Backups should be run in this order:
1. Swarm
2. UCP
3. DTR

## Notes
Persistant volume backups should be handled via other methods.
