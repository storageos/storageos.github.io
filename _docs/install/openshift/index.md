---
layout: guide
title: StorageOS Docs - OpenShift
anchor: install
module: install/openshift
---

# Install with OpenShift

StorageOS can be used as a storage provider for your OpenShift cluster, making
local storage accessible from any node within the OpenShift cluster.  Data can
be replicated to protect against node failure.

At its core, StorageOS provides block storage.  You may choose the filesystem
type to install to make devices usable from within containers.

## Prerequisites

You will need an OpenShift 3.8+ cluster with Beta APIs enabled.

1. Make sure your docker installation has mount propagation enabled.
```
# A successful run is proof that mount propagation is enabled
docker run -it --rm -v /mnt:/mnt:shared busybox sh -c /bin/date
```
1. The [iptables rules]({% link _docs/install/prerequisites/firewalls.md %}) required for StorageOS.
1. Enable the `MountPropagation` flag by appending feature gates to the api and controller (you can apply these changes using the Ansible Playbooks)
- Add to the KubernetesMasterConfig section (/etc/origin/master/master-config.yaml):

    ```
kubernetesMasterConfig:
  apiServerArguments:
    feature-gates:
    - MountPropagation=true
  controllerArguments:
    feature-gates:
    - MountPropagation=true
    ```

- Add to the feature-gates to the kubelet arguments (/etc/origin/node/node-config.yaml):

    ```
kubeletArguments:
  feature-gates:
  - MountPropagation=true
    ```

- **Warning:** Restarting OpenShift services can cause downtime in the cluster.
- Restart services in the MasterNode `origin-master-api.service`, `origin-master-controllers.service` and `origin-node.service`
- Restart service in all Nodes `origin-node.service`


For OpenShift 3.7, you can [install the container directly in
Docker]({%link _docs/install/docker/index.md %}).

## Install with Helm

StorageOS container needs privileged execution permissions. Because of that it is required to add a security context constraint. 

```bash
RELEASE=my-release # Name of the release for storageos Chart
oc --as system:admin create serviceaccount $RELEASE-storageos -n default
oc --as system:admin adm policy add-scc-to-user privileged system:serviceaccount:default:$RELEASE-storageos
```

[Install Helm](https://blog.openshift.com/getting-started-helm-openshift)

```bash
$ git clone https://github.com/storageos/helm-chart.git storageos
$ cd storageos
$ helm install --name $RELEASE .

# Follow the instructions printed by helm install to update the link between Kubernetes and StorageOS.
$ ClusterIP=$(kubectl get svc/storageos --namespace kube-system -o custom-columns=IP:spec.clusterIP --no-headers=true)
$ ApiAddress=$(echo -n "tcp://$ClusterIP:5705" | base64)
$ kubectl patch secret/storageos-api --namespace kube-system --patch "{\"data\":{\"apiAddress\": \"$ApiAddress\"}}"
```

To uninstall the release with all related Kubernetes components:

```bash
$ helm delete --purge $RELEASE
```

[See further configuration options.](https://github.com/storageos/helm-chart#configuration)
