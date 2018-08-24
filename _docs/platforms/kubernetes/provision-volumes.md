---
layout: guide
title: StorageOS Docs - Provision volumes
anchor: platforms
module: platforms/kubernetes/provision-volumes
---

This document describes how to provision StorageOS volumes. Administrators
define storage profiles using Kubernetes StorageClasses, and users request
storage volumes using PersistentVolumeClaims (PVCs).

Create all examples below:
```bash
git clone https://github.com/storageos/deploy.git storageos
kubectl create -f storageos/examples/
```

## Storage class

```bash
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
  labels:
    app: storageos
provisioner: kubernetes.io/storageos
parameters:
  fsType: ext4
  pool: default
  adminSecretNamespace: default
  adminSecretName: storageos-api
```

StorageOS supports the following storage class parameters:

- `pool`: The name of the StorageOS distributed capacity pool to provision the
  volume from; defaults to `default`.
- `fsType`: The default filesystem type to request. Note that user-defined
  rules within StorageOS may be used to override this value. Defaults to `ext4`.

The following parameters can be set only if CSI credentials are
enabled:

- `csiProvisionerSecretName`: The name of the secret to use for obtaining the
CSI provisioner credentials.
- `csiProvisionerSecretNamespace`: The namespace where the CSI provisioner
credentials secret are located.
- `csiControllerPublishSecretName`: The name of the secret to use for obtaining
the CSI controller publish credentials.
- `csiControllerPublishSecretNamespace`: The namespace where the CSI controller
publish credentials secret is located.
- `csiNodeStageSecretName`: The name of the secret to use for obtaining the CSI
node stage credentials.
- `csiNodeStageSecretNamespace`: The namespace where the CSI node stage
credentials secret is located.
- `csiNodePublishSecretName`: The name of the secret to use for obtaining the
CSI node publish credentials.
- `csiNodePublishSecretNamespace`: The namespace where the CSI node publish
credentials secret is located.

## Persistent volume claim

```bash
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-vol-1
  annotations:
    volume.beta.kubernetes.io/storage-class: fast
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

## Replicated volumes

With CSI deployments, you can enable replication on a storage class so that all
PVCs created from the storage class will have replication enabled by default:

```bash
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-label
parameters:
  fsType: ext4
  pool: default
  storageos.com/replicas: "1"
provisioner: storageos
```

With non-CSI deployments, you can enable replication on an individual persistent
volume:

```bash
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-vol-1
  labels:
      storageos.com/replicas: "1"
  annotations:
    volume.beta.kubernetes.io/storage-class: fast
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```
