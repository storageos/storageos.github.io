---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: install
module: install/kubernetes
---

# Kubernetes

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [GCE/GKE Installation](#gce)
- [Examples](#examples)
  - [Pre-provisioned Volumes](#pre-provisioned)
    - [Pod](#pod)
    - [Persistent Volumes](#persistent-volumes)
  - [Dynamic Provisioning](#dynamic-provisioning)
    - [Storage Class](#storage-class)
- [API Configuration](#api-configuration)

## Overview

StorageOS can be used as a storage provider for your Kubernetes cluster.
StorageOS runs as a container within your Kubernetes environment, making local
storage accessible from any node within the Kubernetes cluster.  Data can be
replicated to protect against node failure.

At its core, StorageOS provides block storage.  You may choose the filesystem
type to install to make devices usable from within containers.

## Prerequisites

1. StorageOS K8S support is only available for Kubernetes 1.7+.

2. The `storageos/node` container must be running on each node that wants to contribute
storage or that wants to consume storage.  To install our StorageOS container
on kubernetes using DaemonSet follow the steps below.

3. A consul cluster running that is accessible from the kubernetes cluster, the consul servers
can only be able to be used for one StorageOS cluster at a time (dedicated StorageOS cluster).

## GCE/GKE Installation

* Note: Currently GKE does not support Kubernetes 1.7. We expect to support GKE when it upgrades the supported
kubernetes version to 1.7+. The following instructions are for GCE with a 1.7 Kubernetes release installed.

StorageOS needs to run on every node, which makes Kubernetes DaemonSets the ideal deployment method.
Before we can create our `daemonSet` we need to enable shared mount propagation to the container
for `/var/lib/storageos` and (optionally) enable nbd for faster performance on some workloads.

### Configuring mount propagation

* For container optimised (`cos` image) based cluster:

  Add the following systemd config override

  ```bash
  sudo su
  cat > /etc/systemd/system/docker.service.d/02storageos.conf << EOF
  [service]
  MountFlags=rshared
  EOF
  ```

  Then restart the daemon:

  ```bash
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```

* For `container-vm` based cluster:

  On each node:

  ```bash
  sudo mkdir /var/lib/storageos
  sudo mount -o bind /var/lib/storageos /var/lib/storageos
  sudo mount --make-rshared /var/lib/storageos
  ```

### Enabling NBD

NBD is a default Linux kernel module that allows block devices to be run in userspace. Enabling NBD is recommended as it will increase performance for some workloads. To enable the module and increase the number of allowable devices, you must either run the following
steps on every node.

```bash
$ sudo modprobe nbd nbds_max=1024
```

**To ensure the NBD module is loaded on reboot.**

1. Add the following line to `/etc/modules`
```
nbd
```

2. Add the following module configuration line in `/etc/modprobe.d/nbd.conf`
```
options nbd nbds_max=1024
```

Depending on the VM image that is running kubernetes this means the following
steps are required to run on each node.


### Creating the DaemonSet

Once mount propagation is configured appropriately you may deploy storageos with the following
daemonSet:

```YAML
---
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: storageos
spec:
  template:
    metadata:
      labels:
        name: storageos
      annotations:
        volume.alpha.kubernetes.io/propagation: "{\"storageos\": {\"lib\": \"rshared\"}}"
    spec:
      hostPID: true
      containers:
      - name: storageos
        image: storageos/node
        args:
        - server
        env:
        - name: HOSTNAME
          value: ""
        - name: KV_BACKEND
          value: "consul"
        - name: KV_ADDR
          value: $KV_ADDR
        - name: ADVERTISE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        volumeMounts:
        - name: fuse
          mountPath: /dev/fuse
        - name: lib
          mountPath: /var/lib/storageos
        securityContext:
          privileged: true
          capabilities:
            add:
            - SYS_ADMIN
      volumes:
        - name: fuse
          hostPath:
            path: /dev/fuse
        - name: lib
          hostPath:
            path: /var/lib/storageos
```

### Self-managed StorageOS install

Alternatively, StorageOS can be installed as a standard Docker container on each
minion (see [Docker Application Container]({% link _docs/install/docker/container.md %}))
that runs outside of Kubernetes control.


## API Configuration

The StorageOS provider has been pre-configured to use the StorageOS API
defaults, and no additional configuration is required for testing.  If you have
changed the API port, or have removed the default account or changed its
password (recommended), you must specify the new settings.  This is done using
Kubernetes [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).

API configuration is set by using Kubernetes secrets.  The configuration secret
supports the following parameters:

- `apiAddress`: The address of the StorageOS API.  This is optional and
  defaults to `tcp://localhost:5705`, which should be correct if the StorageOS
  container is running using the default settings.
- `apiUsername`: The username to authenticate to the StorageOS API with.
- `apiPassword`: The password to authenticate to the StorageOS API with.
- `apiVersion`: Optional, string value defaulting to `1`.

Mutiple credentials can be used by creating different secrets.

For Persistent Volumes, secrets must be created in the Pod namespace.  Specify
the secret name using the `secretName` parameter when attaching existing volumes
in Pods or creating new persistent volumes.

For dynamically provisioned volumes using storage classes, the secret can be
created in any namespace.  Note that you would want this to be an
admin-controlled namespace with restricted access to users. Specify the secret
namespace as parameter `adminSecretNamespace` and name as parameter
`adminSecretName` in storage classes.

Example spec:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: storageos-secret
type: "kubernetes.io/storageos"
data:
  apiAddress: dGNwOi8vMTI3LjAuMC4xOjU3MDU=
  apiUsername: c3RvcmFnZW9z
  apiPassword: c3RvcmFnZW9z
```

Values for `apiAddress`, `apiUsername` and `apiPassword` can be generated with:

```bash
$ echo -n "tcp://127.0.0.1:5705" | base64
dGNwOi8vMTI3LjAuMC4xOjU3MDU=
```

Create the secret:

```bash
$ kubectl create -f storageos-secret.yaml
secret "storageos-secret" created
```

Verify the secret:

```bash
$ kubectl describe secret storageos-secret
Name:		storageos-secret
Namespace:	default
Labels:		<none>
Annotations:	<none>

Type:	kubernetes.io/storageos

Data
====
apiAddress:	20 bytes
apiPassword:	8 bytes
apiUsername:	8 bytes

```

## Examples

These examples assume you have a running Kubernetes cluster with the StorageOS
container running on each node.

### Pre-provisioned Volumes

#### Pod

Pods can be created that access volumes directly.

1. Create a volume using the StorageOS CLI or API.  Consult the
   [volume documentation]({% link _docs/reference/cli/volume.md %}) for details.

1. Create a pod that refers to the new volume.  In this case the volume is named
   `redis-vol01`.

   Example spec:

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     labels:
       name: redis
       role: master
     name: test-storageos-redis
   spec:
     containers:
       - name: master
         image: kubernetes/redis:v1
         env:
           - name: MASTER
             value: "true"
         ports:
           - containerPort: 6379
         resources:
           limits:
             cpu: "0.1"
         volumeMounts:
           - mountPath: /redis-master-data
             name: redis-data
     volumes:
       - name: redis-data
         storageos:
           # This volume must already exist within StorageOS
           volumeName: redis-vol01
           # volumeNamespace is optional, and specifies the volume scope within
           # StorageOS.  If no namespace is provided, it will use the namespace
           # of the pod.  Set to `default` or leave blank if you are not using
           # namespaces.
           volumeNamespace: test-storageos
           # The filesystem type to format the volume with, if required.
           fsType: ext3
   ```

   Create the pod:

   ```bash
   kubectl create -f examples/volumes/storageos/storageos-pod.yaml
   ```

   Verify that the pod is running:

   ```bash
   $ kubectl get pods test-storageos-redis
   NAME                   READY     STATUS    RESTARTS   AGE
   test-storageos-redis   1/1       Running   0          30m
   ```

### Persistent Volumes

1. Create a volume using the StorageOS CLI or API.  Consult the
   [volume documentation]({% link _docs/reference/cli/volume.md %}) for details.

1. Create the persistent volume `redis-vol01`.

   Example spec:

   ```yaml
   apiVersion: v1
   kind: PersistentVolume
   metadata:
     name: pv0001
   spec:
     capacity:
       storage: 5Gi
     accessModes:
       - ReadWriteOnce
     persistentVolumeReclaimPolicy: Recycle
     storageos:
       # This volume must already exist within StorageOS
       volumeName: pv0001
       # volumeNamespace is optional, and specifies the volume scope within
       # StorageOS.  Set to `default` or leave blank if you are not using
       # namespaces.
       volumeNamespace: default
       # The filesystem type to create on the volume, if required.
       fsType: ext4
   ```

   Create the persistent volume:

   ```bash
   kubectl create -f examples/volumes/storageos/storageos-pv.yaml
   ```

   Verify that the pv has been created:

   ```bash
   $ kubectl describe pv pv0001
   Name:           pv0001
   Labels:         <none>
   StorageClass:
   Status:         Available
   Claim:
   Reclaim Policy: Recycle
   Access Modes:   RWO
   Capacity:       5Gi
   Message:
   Source:
       Type:            StorageOS (a StorageOS Persistent Disk resource)
       VolumeName:      pv0001
       VolumeNamespace: default
       FSType:          ext4
       ReadOnly:        false
   No events.
   ```

1. Create persistent volume claim

   Example spec:

   ```yaml
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: pvc0001
   spec:
     accessModes:
       - ReadWriteOnce
     resources:
       requests:
         storage: 5Gi
   ```

   Create the persistent volume claim:

   ```bash
   kubectl create -f examples/volumes/storageos/storageos-pvc.yaml
   ```

   Verify that the pvc has been created:

   ```bash
   $ kubectl describe pvc pvc0001
   Name:          pvc0001
   Namespace:     default
   StorageClass:
   Status:        Bound
   Volume:        pv0001
   Labels:        <none>
   Capacity:      5Gi
   Access Modes:  RWO
   No events.
   ```

1. Create pod which uses the persistent volume claim

   Example spec:

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     labels:
       name: redis
       role: master
     name: test-storageos-redis-pvc
   spec:
     containers:
       - name: master
         image: kubernetes/redis:v1
         env:
           - name: MASTER
             value: "true"
         ports:
           - containerPort: 6379
         resources:
           limits:
             cpu: "0.1"
         volumeMounts:
           - mountPath: /redis-master-data
             name: redis-data
     volumes:
       - name: redis-data
         persistentVolumeClaim:
           claimName: pvc0001
   ```

   Create the pod:

   ```bash
   kubectl create -f examples/volumes/storageos/storageos-pvcpod.yaml
   ```

   Verify that the pod has been created:

   ```bash
   $ kubectl get pods
   NAME                       READY     STATUS    RESTARTS   AGE
   test-storageos-redis-pvc   1/1       Running   0          40s
   ```

### Dynamic Provisioning

Dynamic provisioning can be used to auto-create volumes when needed.  They
require a Storage Class, a Persistent Volume Claim, and a Pod.

#### Storage Class

Kubernetes administrators can use storage classes to define different types of
storage made available within the cluster.  Each storage class definition
specifies a provisioner type and any parameters needed to access it, as well as
any other configuration.

StorageOS supports the following storage class parameters:

- `pool`: The name of the StorageOS distributed capacity pool to provision the
  volume from.  Uses the `default` pool which is normally present if not
  specified.
- `description`: The description to assign to volumes that were created
  dynamically.  All volume descriptions will be the same for the storage class,
  but different storage classes can be used to allow descriptions for different
  use cases.  Defaults to `Kubernetes volume`.
- `fsType`: The default filesystem type to request.  Note that user-defined
  rules within StorageOS may override   this value.  Defaults to `ext4`.
- `adminSecretNamespace`: The namespace where the API configuration secret is
  located. Required if adminSecretName set.
- `adminSecretName`: The name of the secret to use for obtaining the StorageOS
  API credentials. If not specified, default values will be attempted.

1. Create storage class

   Example spec:

   ```yaml
   kind: StorageClass
   apiVersion: storage.k8s.io/v1beta1
   metadata:
     name: fast
   provisioner: kubernetes.io/storageos
   parameters:
     pool: default
     description: Kubernetes volume
     fsType: ext4
     adminSecretNamespace: default
     adminSecretName: storageos-secret
   ```

   Create the storage class:

   ```bash
   kubectl create -f examples/volumes/storageos/storageos-sc.yaml
   ```

   Verify the storage class has been created:

   ```bash
   $ kubectl describe storageclass fast
   Name:           fast
   IsDefaultClass: No
   Annotations:    <none>
   Provisioner:    kubernetes.io/storageos
   Parameters:     description=Kubernetes volume,fsType=ext4,pool=default
   No events.
   ```

1. Create persistent volume claim

   Example spec:

   ```yaml
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: fast0001
     annotations:
       volume.beta.kubernetes.io/storage-class: fast
   spec:
     accessModes:
       - ReadWriteOnce
     resources:
       requests:
         storage: 5Gi
   ```

   Create the persistent volume claim (pvc):

   ```bash
   kubectl create -f examples/volumes/storageos/storageos-sc-pvc.yaml
   ```

   Verify the pvc has been created:

   ```bash
   $ kubectl describe pvc fast0001
   Name:         fast0001
   Namespace:    default
   StorageClass: fast
   Status:       Bound
   Volume:       pvc-480952e7-f8e0-11e6-af8c-08002736b526
   Labels:       <none>
   Capacity:     5Gi
   Access Modes: RWO
   Events:
     <snip>
   ```

   A new persistent volume will also be created and bound to the pvc:

   ```bash
   $ kubectl describe pv pvc-480952e7-f8e0-11e6-af8c-08002736b526
   Name:            pvc-480952e7-f8e0-11e6-af8c-08002736b526
   Labels:          storageos.driver=filesystem
   StorageClass:    fast
   Status:          Bound
   Claim:           default/fast0001
   Reclaim Policy:  Delete
   Access Modes:    RWO
   Capacity:        5Gi
   Message:
   Source:
       Type:            StorageOS (a StorageOS Persistent Disk resource)
       VolumeName:      pvc-480952e7-f8e0-11e6-af8c-08002736b526
       VolumeNamespace: default
       FSType:          ext4
       ReadOnly:        false
   No events.
   ```

1. Create pod which uses the persistent volume claim

   Example spec:

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     labels:
       name: redis
       role: master
     name: test-storageos-redis-sc-pvc
   spec:
     containers:
       - name: master
         image: kubernetes/redis:v1
         env:
           - name: MASTER
             value: "true"
         ports:
           - containerPort: 6379
         resources:
           limits:
             cpu: "0.1"
         volumeMounts:
           - mountPath: /redis-master-data
             name: redis-data
     volumes:
       - name: redis-data
         persistentVolumeClaim:
           claimName: fast0001
   ```

   Create the pod:

   ```bash
   kubectl create -f examples/volumes/storageos/storageos-sc-pvcpod.yaml
   ```

   Verify that the pod has been created:

   ```bash
   $ kubectl get pods
   NAME                          READY     STATUS    RESTARTS   AGE
   test-storageos-redis-sc-pvc   1/1       Running   0          44s
   ```
