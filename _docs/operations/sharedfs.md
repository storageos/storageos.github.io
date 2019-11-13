---
layout: guide
title: StorageOS Docs - Provision RWX Volumes
anchor: operations
module: operations/sharedfs-rwx
---

# Shared Filesystem

> Shared filesystems in the {{ site.latest_node_version }} release are
> currently in Technology Preview. This __experimental feature__ is not yet
> intended for production use.

Shared Filesystem support allows volumes to be mounted for read & write access
by multiple containers simultaneously, even from different nodes.  In
Kubernetes, shared filesystems are referred to as `ReadWriteMany` or RWX
volumes.

See the [architecture]({%link _docs/concepts/sharedfs.md %}) for more
information about the Shared Filesystem components.

## How to provision ReadWriteMany Volumes

RWX Volumes are dynamically provisioned by StorageOS when using a StorageOS
Kubernetes StorageClass. To create an RWX volume set the AccessMode
for the PVC to `ReadWriteMany`.

An example of a RWX PersistentVolumeClaim is shown below:

```bash
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: shared-vol
  labels:
    storageos.com/replicas: "1" # Enable features using Labels
                                # You can enable replication in the
                                # StorageClass params to set defaults
spec:
  storageClassName: "fast" # StorageOS StorageClass
  accessModes:
    - ReadWriteMany # AccessMode that triggers creation of an NFS based StorageOS Volume
  resources:
    requests:
      storage: 20Gi
```

The following Deployment example shows how multiple Nginx Pods can mount the
same shared filesystem PVC.

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
        volumeMounts:
        - name: docroot
          mountPath: /usr/share/nginx/html
      volumes:
      - name: docroot
        persistentVolumeClaim:
          claimName: shared-vol
```

> Only installations of StorageOS using CSI support RWX Volumes. For more
> information, check the [CSI Note](/docs/platforms/kubernetes/install#csi-container-storage-interface-note).

## Volume Deletion

Shared volumes can be deleted through standard Kubernetes PVC deletion. When
a RWX PVC is deleted, StorageOS acts differently according to the
`ReclaimPolicy` of the PVC. For more information about the `ReclaimPolicy`
field see the [Kubernetes
Documentation](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#reclaiming).

### Reclaim Policy

The default reclaim policy for a PVC, PV pair is defined in the StorageClass.
All PVs created by a StorageClass inherit the `reclaimPolicy` set
in the StorageClass.

```bash
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  labels:
    app: storageos
  name: storageos
parameters:
  csi.storage.k8s.io/fstype: ext4
  pool: default
provisioner: storageos
reclaimPolicy: Delete # <----- Default reclaim policy
```

- Delete (default)

If the RWX PVC is deleted then the RWX PV is deleted along with the NFS server
StatefulSet and its underlying RWO volume. As such data written to the RWX
volume is non-recoverable after deletion.

- Retain

The RWX PVC is deleted but the PV remains available. The NFS server StatefulSet
remains untouched along with its associated RWO PVC. Hence, it is possible to
reuse the volume and have access to data written to the RWX volume after the
RWX PVC has been deleted.

In order to reuse the NFS server to serve a different RWX PVC, it is is
necessary to "unlock" the PV, which only Kubernetes administrators with
privileges can do. The PV is "unlocked" by deleteing the `spec.claimRef` field
from the PV.

For instance given a RWX PVC,`pvc-1` was bound to the PV `pv-1`, before
`pvc-1` was deleted. Then in order to reuse `pv-1` edit the PV, i.e `kubectl
edit pv pv-1` and delete the `spec.claimRef` attribute.

Deletion of the `spec.claimRef` field makes the PV available for any new PVC
whose requirements are met by the PV. Therefore creating a new RWX volume
with the previously used; StorageClass, capacity, access type and filesystem
will make the PVC bind to the previously used RWX PV, even if the new PVC is
provisioned in a different namespace.
