---
layout: guide
title: StorageOS Docs - Kubernetes (CSI)
anchor: install
module: install/kubernetes-csi/dynamic-provisioning
---

# Dynamic Provisioning (CSI)

StorageOS supports the [Container Storage Interface](https://kubernetes-csi.github.io/docs/)
which defines a common integration layer between orchestrators such as
Kubernetes and external storage providers such as StorageOS.

CSI removes the requirement for Kubernetes to connect directly to the StorageOS
API, which gives more flexibility in configuration and allows updates to be
applied independently of the Kubernetes release cycle.

We expect the CSI connection method to become the preferred method in Kubernetes
1.11, with deprecation of the native driver in Kubernetes 1.12.

With CSI, StorageOS volumes can be created on-demand through dynamic provisioning.

1. Adminstrators create storage classes to define different types of storage.
1. Users create a persistent volume claim (PVC).
1. The user references the PVC in a pod.

If you are using the [StorageOS Helm chart for deployment](https://github.com/storageos/helm-chart/blob/master/README-CSI.md),
it includes the storage class, so you may skip to step 2 to provision volumes.

## 1. Create storage class

StorageOS supports the following storage class parameters:

- `pool`: The name of the StorageOS distributed capacity pool to provision the
  volume from; defaults to `default`.
- `fsType`: The default filesystem type to request. Note that user-defined
  rules within StorageOS may be used to override this value. Defaults to `ext4`.

Additionally, the following parameters can be set only if CSI credentials are
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

Create a `fast` storage class backed by StorageOS:

```yaml
cat > storageos-sc.yaml <<EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1beta1
metadata:
  name: fast
provisioner: storageos
parameters:
  pool: default
  fsType: ext4
EOF
```

```bash
kubectl create -f storageos-sc.yaml
```

Verify the storage class has been created:

```bash
Name:                  fast
IsDefaultClass:        No
Annotations:           <none>
Provisioner:           storageos
Parameters:            fsType=ext4,pool=default
AllowVolumeExpansion:  <unset>
MountOptions:          <none>
ReclaimPolicy:         Delete
VolumeBindingMode:     Immediate
Events:                <none>
```

## 3. Create persistent volume claim

Create the PVC which uses the `fast` storage class:

```bash
cat > storageos-sc-pvc.yaml <<EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: fast0001
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: fast
  resources:
    requests:
      storage: 5Gi
EOF
```

```bash
kubectl create -f storageos-sc-pvc.yaml
```

Verify the pvc has been created:

```bash
Name:          fast0001
Namespace:     default
StorageClass:  fast
Status:        Bound
Volume:        pvc-03e222ce5e8711e8
Labels:        <none>
Annotations:   control-plane.alpha.kubernetes.io/leader={"holderIdentity":"9a2f70d7-5e86-11e8-8953-9e4ea67f459b","leaseDurationSeconds":15,"acquireTime":"2018-05-23T12:44:34Z","renewTime":"2018-05-23T12:44:36Z","lea...
               kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"v1","kind":"PersistentVolumeClaim","metadata":{"annotations":{},"name":"fast0001","namespace":"default"},"spec":{"accessModes":["ReadWriteOnc...
               pv.kubernetes.io/bind-completed=yes
               pv.kubernetes.io/bound-by-controller=yes
               volume.beta.kubernetes.io/storage-provisioner=storageos
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      5Gi
Access Modes:  RWO
Events:
 <snip>
```

A new persistent volume will also be created and bound to the pvc:

```bash
kubectl describe pvc-03e222ce5e8711e8
Name:            pvc-03e222ce5e8711e8
Labels:          <none>
Annotations:     pv.kubernetes.io/provisioned-by=storageos
Finalizers:      [kubernetes.io/pv-protection]
StorageClass:    fast
Status:          Bound
Claim:           default/fast0001
Reclaim Policy:  Delete
Access Modes:    RWO
Capacity:        5Gi
Node Affinity:   <none>
Message:
Source:
    Type:          CSI (a Container Storage Interface (CSI) volume source)
    Driver:        storageos
    VolumeHandle:  df897c39-d9a7-ebe5-608f-1ef31acc947b
    ReadOnly:      false
Events:            <none>
```

## 4. Create pod

Create the pod which uses the PVC:

```yaml
cat > storageos-sc-pvcpod.yaml <<EOF
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
EOF
```

```bash
kubectl create -f storageos-sc-pvcpod.yaml
```

Verify that the pod has been created:

```bash
kubectl get pods
NAME                          READY     STATUS    RESTARTS   AGE
test-storageos-redis-sc-pvc   1/1       Running   0          44s
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
