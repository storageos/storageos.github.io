---
layout: guide
title: StorageOS Docs - Docker container
anchor: platforms
module: platforms/docker/install
redirect_from: /docs/install/docker/container
redirect_from: install/docker/container
---

# Install with Docker 1.10+

If you are running containers without orchestration, you can create a SystemD
service to run the StorageOS container on each node.

```bash
# Install StorageOS managed by systemd, using Ansible
git clone https://github.com/storageos/deploy.git storageos
cd storageos/systemd-service/deploy-storageos-ansible

# Update hosts to your hostnames and ip addresses
nano hosts
ansible-playbook -i hosts site.yaml
```

{% include envvars.md %}
