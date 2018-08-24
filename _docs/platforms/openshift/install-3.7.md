---
layout: guide
title: StorageOS Docs - Installing on Kubernetes
anchor: platforms
module: platforms/openshift/install-3.7
---

# OpenShift 3.7

Running StorageOS as a daemonset is not supported in OpenShift 3.7, but you can
still deploy StorageOS by running directly in Docker.

```bash
# Install StorageOS managed by SystemD, using Ansible
git clone https://github.com/storageos/deploy.git storageos
cd storageos/openshift/deploy-storageos/storageos-ansible-oc-37

# Update hosts to your hostnames and ip addresses
nano hosts
ansible-playbook -i hosts site.yaml
```

OpenShift 3.6 and earlier are not supported.
