---
layout: guide
title: StorageOS Docs - Create StorageClass
anchor: kubernetes
module: kubernetes/create-storageclass
---

This document describes how an administrator can define storage profiles using
Kubernetes StorageClasses.

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
