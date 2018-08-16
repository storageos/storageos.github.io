---
layout: guide
title: StorageOS Docs - Provision volumes
anchor: kubernetes
module: kubernetes/provision-volumes
---

This document describes how users request storage volumes using
PersistentVolumeClaims (PVCs).

Create all examples below:
```bash
git clone https://github.com/storageos/deploy.git storageos
kubectl create -f storageos/k8s/examples/
```

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
