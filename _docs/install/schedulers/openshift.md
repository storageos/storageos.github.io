---
layout: guide
title: StorageOS Docs - OpenShift
anchor: install
module: install/schedulers/openshift
---

# OpenShift

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Examples](#examples)
  - [Pre-provisioned Volumes](#pre-provisioned)
    - [Pod](#pod)
    - [Persistent Volumes](#persistent-volumes)
  - [Dynamic Provisioning](#dynamic-provisioning)
    - [Storage Class](#storage-class)
- [API Configuration](#api-configuration)
- [Examples cleanup](#examples-cleanup)

## Overview

StorageOS can be used as a storage provider for your OpenShift cluster.
StorageOS runs as a container within your OpenShift environment, making local
storage accessible from any node within the OpenShift cluster.  Data can be
replicated to protect against node failure.

At its core, StorageOS provides block storage.  You may choose the filesystem
type to install to make devices usable from within containers.

## Prerequisites

OpenShift 3.7+ is required.

Run the StorageOS container directly in Docker on each node,
following the instructions at [Docker Application Container]({% link _docs/install/docker/container.md %}).

>**Note**: OpenShift uses iptables, ensure all rules are in place to allow StorageOS to work.

>**Note**: It is not currently possible to run the StorageOS container via
OpenShift in a Pod or Daemonset.  StorageOS and other containerized storage
providers require that mount propagation be enabled using the `rshared` mount
flag which is a Kubernetes 1.8 feature. OpenShift 3.7 uses Kubernetes 1.7 which does not have this feature yet.

## API Configuration

The StorageOS provider has been pre-configured to use the StorageOS API
defaults, only the apiAddress must be set to one of the nodes. This is done using
OpenShift [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).

API configuration is set by using OpenShift secrets.  The configuration secret
supports the following parameters:

- `apiAddress`: The address of the StorageOS API. This must be set to base64(`tcp://<ip address of a node running storageos>:5705`), see below for an example.
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

Example spec: *replace API_ADDRESS with the ip address of one of your StorageOS cluster nodes*

```bash
API_ADDRESS="138.68.183.193"

API=$( echo -n "tcp://${API_ADDRESS}:5705" | base64 )
cat > storageos-secret.yaml <<EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: storageos-secret
type: "kubernetes.io/storageos"
data:
  apiAddress: $API
  apiUsername: c3RvcmFnZW9z
  apiPassword: c3RvcmFnZW9z
...
EOF
```

Values for `apiAddress`, `apiUsername` and `apiPassword` can be generated with:

```bash
echo -n "tcp://10.0.0.1:5705" | base64

dGNwOi8vMTAuMC4wLjE6NTcwNQ==
```

Create the secret:

```bash
oc create -f storageos-secret.yaml

secret "storageos-secret" created
```

Verify the secret:

```bash
oc describe secret storageos-secret

Name:		storageos-secret
Namespace:	default
Labels:		<none>
Annotations:	<none>

Type:	kubernetes.io/storageos

Data
====
apiAddress:	25 bytes
apiPassword:	9 bytes
apiUsername:	9 bytes

```

## Examples

These examples assume you have a running OpenShift cluster with the StorageOS
container running on each node.

### Pre-provisioned Volumes

#### Pod

Pods can be created that access volumes directly.

1. Create a volume using the StorageOS CLI or API.  Consult the
   [volume documentation]({% link _docs/reference/cli/volume.md %}) for details.

   Example command: run on a node with StorageOS set up

   ```bash
   storageos volume create nginx-vol01
   ```

1. Create a pod that refers to the new volume.  In this case the volume is named
   `nginx-vol01`.

   Example spec:

   ```bash
   cat > storageos-pod.yaml <<EOF
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     labels:
       name: nginx
       role: master
     name: test-storageos-nginx
   spec:
     containers:
       - name: master
         image: nginx
         env:
           - name: MASTER
             value: "true"
         ports:
           - containerPort: 80
         resources:
           limits:
             cpu: "0.1"
         volumeMounts:
           - mountPath: /usr/share/nginx/html
             name: nginx-data
     volumes:
       - name: nginx-data
         storageos:
           # This volume must already exist within StorageOS
           volumeName: nginx-vol01
           # volumeNamespace is optional, and specifies the volume scope within
           # StorageOS.  If no namespace is provided, it will use the namespace
           # of the pod.  Set to `default` or leave blank if you are not using
           # namespaces.
           volumeNamespace: default
           # The filesystem type to format the volume with, if required.
           fsType: ext3
   ...
   EOF
   ```

   Create the pod:

   ```bash
   oc create -f storageos-pod.yaml
   ```

   Verify that the pod is running:

   ```bash
   oc get pods test-storageos-nginx

   NAME                   READY     STATUS    RESTARTS   AGE
   test-storageos-nginx   1/1       Running   0          24s
   ```

### Persistent Volumes

1. Create a volume using the StorageOS CLI or API.  Consult the
   [volume documentation]({% link _docs/manage/volumes/index.md %}) for details.

   **Note** this example uses a replicated volume.

   ```bash
   storageos volume create nginx-pv01 --label storageos.com/replicas=1

   default/nginx-pv01
   ```

1. Create the persistent volume `nginx-vol01`.

   Example spec:

   ```bash
   cat > storageos-pv.yaml <<EOF
   ---
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
       volumeName: nginx-pv01
       # volumeNamespace is optional, and specifies the volume scope within
       # StorageOS.  Set to `default` or leave blank if you are not using
       # namespaces.
       volumeNamespace: default
       # The filesystem type to create on the volume, if required.
       fsType: ext4
   ...
   EOF
   ```

   Create the persistent volume:

   ```bash
   oc create -f storageos-pv.yaml
   ```

   Verify that the pv has been created:

   ```bash
   oc describe pv pv0001

   Name:           pv0001
   Labels:         <none>
   Annotations:    <none>
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
   Events:              <none>
   ```

1. Create a persistent volume claim

   Example spec:

   ```bash
   cat > storageos-pvc.yaml <<EOF
   ---
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
   ...
   EOF
   ```

   Create the persistent volume claim:

   ```bash
   oc create -f storageos-pvc.yaml
   ```

   Verify that the pvc has been created:

   ```bash
   oc describe pvc pvc0001

   Name:          pvc0001
   Namespace:     default
   StorageClass:
   Status:        Bound
   Volume:        pv0001
   Labels:        <none>
   Annotations:	  pv.kubernetes.io/bind-completed=yes
		  pv.kubernetes.io/bound-by-controller=yes
   Capacity:	  5Gi
   Access Modes:  RWO
   Events:        <none>
   ```

1. Create a pod which uses the persistent volume claim

   Example spec:

   ```bash
   cat > storageos-pvcpod.yaml <<EOF
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     labels:
       name: nginx
       role: master
     name: test-storageos-nginx-pvc
   spec:
     containers:
       - name: master
         image: nginx
         env:
           - name: MASTER
             value: "true"
         ports:
           - containerPort: 80
         resources:
           limits:
             cpu: "0.1"
         volumeMounts:
           - mountPath: /usr/share/nginx/html
             name: nginx-data
     volumes:
       - name: nginx-data
         persistentVolumeClaim:
           claimName: pvc0001
   ...
   EOF
   ```

   Create the pod:

   ```bash
   oc create -f storageos-pvcpod.yaml
   ```

   Verify that the pod has been created:

   ```bash
   oc get pods test-storageos-nginx-pvc

   NAME                       READY     STATUS    RESTARTS   AGE
   test-storageos-nginx-pvc   1/1       Running   0          1m
   ```

### Dynamic Provisioning

Dynamic provisioning can be used to auto-create volumes when needed.  They
require a Storage Class, a Persistent Volume Claim, and a Pod.

#### Storage Class

OpenShift administrators can use storage classes to define different types of
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

   ```bash
   cat > storageos-sc.yaml <<EOF
   ---
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
   ...
   EOF
   ```

   Create the storage class:

   ```bash
   oc create -f storageos-sc.yaml
   ```

   Verify the storage class has been created:

   ```bash
   oc describe storageclass fast

   Name:           fast
   IsDefaultClass: No
   Annotations:    <none>
   Provisioner:    kubernetes.io/storageos
   Parameters:     adminSecretName=storageos-secret,adminSecretNamespace=default,description=Kubernetes volume,fsType=ext4,pool=default
   Events:         <none>
   ```

1. Create a persistent volume claim

   Example spec:

   ```bash
   cat > storageos-sc-pvc.yaml <<EOF
   ---
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
   ...
   EOF
   ```

   Create the persistent volume claim (pvc):

   ```bash
   oc create -f storageos-sc-pvc.yaml
   ```

   Verify the pvc has been created:

   ```bash
   oc describe pvc fast0001

   Name:         fast0001
   Namespace:    default
   StorageClass: fast
   Status:       Bound
   Volume:       pvc-480952e7-f8e0-11e6-af8c-08002736b526
   Labels:       <none>
   Annotations:	pv.kubernetes.io/bind-completed=yes
		pv.kubernetes.io/bound-by-controller=yes
		volume.beta.kubernetes.io/storage-class=fast
		volume.beta.kubernetes.io/storage-provisioner=kubernetes.io/storageos
   Capacity:     5Gi
   Access Modes: RWO
   Events:
     <snip>
   ```

   A new persistent volume will also be created and bound to the pvc:

   ```bash
   oc describe pv pvc-480952e7-f8e0-11e6-af8c-08002736b526

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
   Events               <none>
   ```

1. Create a pod which uses the persistent volume claim

   Example spec:

   ```bash
   cat > storageos-sc-pvcpod.yaml <<EOF
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     labels:
       name: nginx
       role: master
     name: test-storageos-nginx-sc-pvc
   spec:
     containers:
       - name: master
         image: nginx
         env:
           - name: MASTER
             value: "true"
         ports:
           - containerPort: 80
         resources:
           limits:
             cpu: "0.1"
         volumeMounts:
           - mountPath: /usr/share/nginx/html
             name: nginx-data
     volumes:
       - name: nginx-data
         persistentVolumeClaim:
           claimName: fast0001
   ...
   EOF
   ```

   Create the pod:

   ```bash
   oc create -f storageos-sc-pvcpod.yaml
   ```

   Verify that the pod has been created:

   ```bash
   oc get pods test-storageos-nginx-sc-pvc

   NAME                          READY     STATUS    RESTARTS   AGE
   test-storageos-nginx-sc-pvc   1/1       Running   0          44s
   ```

# Examples cleanup

On the master OpenShift server:

```bash
rm -f storageos-{secrets,pod,pv,pvc,pvcpod,sc,sc-pv,sc-pvcpod}.yaml
oc delete pod test-storageos-nginx-sc-pvc test-storageos-nginx-pvc test-storageos-nginx
oc delete pods $(oc get pods |grep ^test-storageos |cut -d' ' -f 1)

oc delete pvc pvc0001 fast0001
oc delete pv pv0001
oc delete secret storageos-secret
oc delete storageclass fast
```

On an OpenShift node:

```bash
storageos volume rm default/nginx-vol01 default/nginx-pv01
```
