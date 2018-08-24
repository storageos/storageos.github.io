---
layout: guide
title: StorageOS Docs - Installing on Kubernetes 1.10
anchor: platforms
module: platforms/kubernetes/install-1.10
redirect_from: /docs/install/schedulers/kubernetes
redirect_from: /docs/install/kubernetes
---

# Kubernetes 1.10+

The recommended way to run StorageOS on a Kubernetes 1.10+ cluster is to deploy
a DaemonSet with [Container Storage Interface
(CSI)](https://github.com/container-storage-interface/spec) support. Using CSI
ensures forward compatibility with future releases of Kubernetes, as
vendor-specific drivers will be deprecated from Kubernetes 1.12.

```bash
# Install StorageOS as a daemonset with CSI and RBAC support
git clone https://github.com/storageos/deploy.git storageos
cd storageos/k8s/deploy-storageos/csi
kubectl create -f manifests/
```

or using the Helm chart:
```bash
git clone https://github.com/storageos/helm-chart.git storageos
cd storageos
# Set cluster.join to hostnames or ip addresses of at least one node
helm install . --name my-release --set cluster.join=node01,node02,node03 --set csi.enable=true
```

## Non-CSI installs

CSI allows you to set StorageOS features (`storageos.com/*` labels) in
the StorageClass, but not PVCs. If you need to set labels in PVCs (but not
StorageClasses) or your environment does not support CSI, you may install
StorageOS without CSI:

```bash
# Install StorageOS as a daemonset with RBAC support
git clone https://github.com/storageos/deploy.git storageos
cd storageos/k8s/deploy-storageos/standard
./deploy-storageos.sh
```

or using the Helm chart:
```bash
git clone https://github.com/storageos/helm-chart.git storageos
cd storageos
# Set cluster.join to hostnames or ip addresses of at least one node
helm install . --name my-release --set cluster.join=node01,node02,node03

# Follow the instructions printed by helm install to update the link between Kubernetes and StorageOS. They look like:
$ ClusterIP=$(kubectl get svc/storageos --namespace storageos -o custom-columns=IP:spec.clusterIP --no-headers=true)
$ ApiAddress=$(echo -n "tcp://$ClusterIP:5705" | base64)
$ kubectl patch secret/storageos-api --namespace storageos --patch "{\"data\":{\"apiAddress\": \"$ApiAddress\"}}"
```
