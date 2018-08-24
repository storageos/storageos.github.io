---
layout: guide
title: StorageOS Docs - Installing on Kubernetes
anchor: platforms
module: platforms/openshift/install-3.8
---

# Openshift 3.8

StorageOS requires [mount
propagation](https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation)
in order to present devices as volumes to containers. In OpenShift 3.8 this feature is in alpha, so needs to be explicity enabled.

* Set `--feature-gates MountPropagation=true` in the kube-apiserver and
kube-controller-manager deployments, usually found in the master nodes under
`/etc/kubernetes/manifests`.
* Set `KUBELET_EXTRA_ARGS=--feature-gates=MountPropagation=true` in the kubelet
service config. For systemd, this usually is located in `/etc/systemd/system/`.

If the kubelets run as containers, you also need to share the StorageOS data
directory into each of the kubelets by adding
`--volume=/var/lib/storageos:/var/lib/storageos:rshared` to each of the
kubelets.

```bash
# Install StorageOS as a daemonset with RBAC support
git clone https://github.com/storageos/deploy.git storageos
cd storageos/openshift/deploy-storageos/standard
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
