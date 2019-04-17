---
layout: guide
title: StorageOS Docs - Encryption
anchor: operations
module: operations/encrypted-volumes
---

# Encrypted Volumes

Volumes can be encrypted when they are created using the
`storageos.com/encryption label`. The labels can be passed to StorageOS using
PVCs or you can directly create volumes using the StorageOS CLI or GUI with the
encryption label applied. 

For more in depth discussion of how encryption works please see the [Encryption
concepts](/docs/concepts/encryption) page.

## Required labels

The `storageos.com/encryption` label must be applied to the volume when it is
created. The encryption status of a volume cannot be changed after a volume has been
created.

You can pass the label using a PVC

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc0002
  labels:
    "storageos.com/encryption": "true"
  annotations:
    volume.beta.kubernetes.io/storage-class: fast
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

You can also pass the encryption label when creating volumes using the CLI
```bash
$ storageos volume create encrypted --label storageos.com/encryption=true
```

You can also add the encryption label when creating a volume with the GUI

## Backing up Secrets

StorageOS generates the cryptographic keys that are used to encrypt data (see
[Encryption](/docs/concepts/encryption) for more details). The keys that are
used to encrypt a volume are stored in a Kubernetes secret. As such, StorageOS
does not have access to the keys that are used to encrypt a volume and if the
keys are lost the volume **cannot** be decrypted.

As a precautionary measure it is recommended that you backup the Kubernetes secrets
used to store the encryption keys.

StorageOS will create one secret per encrypted volume and the secrets are
created in whatever namespace StorageOS is installed into.
```bash
$ kubectl get secrets -n storageos
NAME                                           TYPE                                  DATA   AGE
ns-key.default                                 Opaque                                1      20h
vol-key.4276fc07-7d85-70bf-35a0-f0b005e55e0f   Opaque                                4      1m
```
In the output above there is a `ns-key.default` and a `vol-key.`
>A `ns-key` is created for each [StorageOS namespace](/docs/concepts/namespaces)
>in the format `ns-key.{namespace}`. A `vol-key` is created for every encrypted
>volume. The vol-keys are named `vol-key.{volume-id}`. The volume id can be
>retrieved by inspecting the volume.

```bash
# Find the PVC name
$ kubectl get pvc --show-labels
NAME      STATUS   VOLUME                                     STORAGECLASS   AGE   LABELS
pvc0002   Bound    pvc-1c68f013-40dd-11e9-91ad-0a57700a78b4   fast           10m   storageos.com/encryption=true

# Inspect the volume and find the volume ID
$ storageos volume inspect default/pvc-1c68f013-40dd-11e9-91ad-0a57700a78b4 | grep -m1 id
        "id": "4276fc07-7d85-70bf-35a0-f0b005e55e0f",

# Find the secret for PVC pvc0002
$ kubectl get secret vol-key.4276fc07-7d85-70bf-35a0-f0b005e55e0f
NAME                                           TYPE     DATA   AGE
vol-key.4276fc07-7d85-70bf-35a0-f0b005e55e0f   Opaque   4      12m
```

StorageOS recommends that vol-key and ns-keys are backed up. This can be done
by outputting the secrets as yaml and storing the resulting files securely.
The example below will output the ns-key.default to a ns-key.default.yaml file.
```bash
$ kubectl get secret ns-key.default -o yaml > ns-key.default.yaml
```
**The vol-key secret contains all the keys necessary to decrypt a volume so
ensure that backups of the vol-keys are stored securely.**

## Restoring Secrets

In order to restore backed up secrets use kubectl to create them. The secrets
have a namespace field in the file themselves so a namespace does not need to
be specified.

```bash
$ kubectl create -f ns-key.default.yaml
```
Keys can be restored while StorageOS is running and will be used dynamically by
StorageOS.
