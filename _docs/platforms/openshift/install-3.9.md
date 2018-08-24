---
layout: guide
title: StorageOS Docs - Installing on OpenShift 3.9
anchor: platforms
module: platforms/openshift/install-3.9
---

# OpenShift 3.9+

The recommended way to run StorageOS on an OpenShift 3.9+ cluster is to deploy
a daemonset with RBAC support.

```bash
git clone https://github.com/storageos/deploy.git storageos
cd storageos/openshift/deploy-storageos/standard
./deploy-storageos.sh
```
