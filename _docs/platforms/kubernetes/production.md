---
layout: guide
title: StorageOS Docs - Production deployments
anchor: platforms
module: platforms/kubernetes/production
---

# Production deployments

## Deploy StorageOS with an external key-value store

```bash
git clone https://github.com/storageos/deploy.git storageos
cd storageos/k8s/deploy-storageos/external-etcd

# Set the addresses of your etcd nodes
nano manifests/025_etcd_service.yaml
deploy-storageos.sh
```

## Mixed deployment types

```bash
# Label each node that runs StorageOS in compute only and mixed storage/compute nodes. Unlabelled nodes do not run StorageOS and pods on these nodes may not mount StorageOS volumes.
kubectl label node MY_NODE storageos=compute-only
kubectl label node MY_NODE storageos=storage

git clone https://github.com/storageos/deploy.git storageos
cd storageos/k8s/deploy-storageos/labeled-deployment
./deploy-storageos.sh
```

## Enable CSI Credentials

The default CSI unix domain socket is open and insecure. To secure it with
authentication credentials, the StorageOS container should be started with
knowledge of the credentials that will be used for various actions.

The credentials should also be stored in secrets and refered to in the storage
class.

To enable CSI credentials using the [StorageOS helm chart](https://github.com/storageos/helm-chart/blob/master/README-CSI.md),
edit the values.yaml file and enable the various credential options.

```yaml
csi:
  # provisionCreds are credentials for volume create and delete operations.
  provisionCreds:
    enable: true
    username: username1
    password: password1
    secretName: storageos-provision-creds
  # controllerPublishCreds are credentials for controller volume publish and unpublish operations.
  controllerPublishCreds:
    enable: true
    username: username2
    password: password2
    secretName: storageos-ctrl-publish-creds
  # nodeStageCreds are credentials for node volume stage operations.
  nodeStageCreds:
    enable: true
    username: username3
    password: password3
    secretName: storageos-node-stage-creds
  # nodePublishCreds are credentials for node volume publish operations.
  nodePublishCreds:
    enable: true
    username: username4
    password: password4
    secretName: storageos-node-publish-creds
```

When the chart is installed with the credential options above set:

1. StorageOS node containers are started with the credentials granted access.
1. Kubernetes secrets containing the credentials are created.
1. A StorageClass is created with references to the credential secrets.

When CSI Credentials are configured, requests with incorrect or no credentials
are denied.

Example of a StorageClass with CSI credentials:

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast
provisioner: storageos
parameters:
  pool: default
  fsType: ext4

  # CSI credentials config.
  csiProvisionerSecretName: storageos-provision-creds
  csiProvisionerSecretNamespace: storageos
  csiControllerPublishSecretName: storageos-ctrl-publish-creds
  csiControllerPublishSecretNamespace: storageos
  csiNodeStageSecretName: storageos-node-stage-creds
  csiNodeStageSecretNamespace: storageos
  csiNodePublishSecretName: storageos-node-publish-creds
  csiNodePublishSecretNamespace: storageos
```

Example of a secret used in CSI credentials:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: storageos-provision-creds
  namespace: storageos
type: Opaque
data:
  username: "dXNlcm5hbWUx"
  password: "cGFzc3dvcmQx"
```

The data values must be base64 encoded.

Refer to the [Kubernetes-CSI docs](https://kubernetes-csi.github.io/docs/) for
more information about CSI.
