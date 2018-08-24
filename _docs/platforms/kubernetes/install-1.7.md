---
layout: guide
title: StorageOS Docs - Installing on Kubernetes
anchor: platforms
module: platforms/kubernetes/install-1.7
---

# Kubernetes 1.7

Running StorageOS as a daemonset is not supported in Kubernetes 1.7, but you can
still deploy StorageOS by running directly in Docker.

```bash
# Install StorageOS managed by SystemD, using Ansible
git clone https://github.com/storageos/deploy.git storageos
cd storageos/systemd-service/deploy-storageos-ansible

# Update hosts to your hostnames and ip addresses
nano hosts
ansible-playbook -i hosts site.yaml
```

Kubernetes 1.6 and earlier are not supported.
