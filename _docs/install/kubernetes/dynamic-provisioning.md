---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: install
module: install/kubernetes/dynamic-provisioning
---

# Dynamic Provisioning

StorageOS volumes can be created on-demand through dynamic provisioning.

1. Create the secret needed to authenticate against the StorageOS API.
1. Adminstrators create storage classes to define different types of storage.
1. Users create a persistent volume claim (PVC).
1. The user references the PVC in a pod.

The [StorageOS Helm chart](https://github.com/storageos/helm-chart) includes the
secret and storage class, so you may skip to step 3 to provision volumes.

## 1. Create secret

You need to provide the correct credentials to authenticate against the StorageOS API
using [Kubernetes
secrets](https://kubernetes.io/docs/concepts/configuration/secret/). The
configuration secret supports the following parameters:

- `apiAddress`: The address of the StorageOS API. Defaults to `tcp://localhost:5705`.
- `apiUsername`: The username to authenticate to the StorageOS API with.
- `apiPassword`: The password to authenticate to the StorageOS API with.
- `apiVersion`: The API version. Defaults to `1`.

The StorageOS provider has been pre-configured to use the StorageOS API
defaults.  If you have changed the API port, removed the default account or
changed its password (recommended), you must specify the new settings in
`apiAddress`, `apiUsername` and `apiPassword`, encoded as base64 strings.

```bash
echo -n "tcp://127.0.0.1:5705" | base64
dGNwOi8vMTI3LjAuMC4xOjU3MDU=
```

Create the secret:

```bash
cat > storageos-secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: storageos-secret
type: "kubernetes.io/storageos"
data:
  apiAddress: dGNwOi8vMTI3LjAuMC4xOjU3MDU=
  apiUsername: c3RvcmFnZW9z
  apiPassword: c3RvcmFnZW9z
EOF
```
```
kubectl create -f storageos-secret.yaml
secret "storageos-secret" created
```


Verify the secret:

```bash
kubectl describe secret storageos-secret
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

For dynamically provisioned volumes using storage classes, the secret can be
created in any namespace.  Note that you would want this to be an
admin-controlled namespace with restricted access to users. Specify the secret
namespace as parameter `adminSecretNamespace` and name as parameter
`adminSecretName` in storage classes.

For Persistent Volumes, secrets must be created in the Pod namespace.  Specify
the secret name using the `secretName` parameter when attaching existing volumes
in Pods or creating new persistent volumes.

Mutiple credentials can be used by creating different secrets.

The Kubernetes master needs to be able to access the api, so if the master
doesn't run the storageos container then a LoadBalancer ip may be needed.

## 2. Create storage class

StorageOS supports the following storage class parameters:

- `pool`: The name of the StorageOS distributed capacity pool to provision the
  volume from; defaults to `default`.
- `description`: The description to assign to volumes that were created
  dynamically.  All volume descriptions will be the same for the storage class,
  but different storage classes can be used to allow descriptions for different
  use cases.  Defaults to `Kubernetes volume`.
- `fsType`: The default filesystem type to request. Note that user-defined
  rules within StorageOS may override this value. Defaults to `ext4`.
- `adminSecretNamespace`: The namespace where the API configuration secret is
  located. Required if adminSecretName set.
- `adminSecretName`: The name of the secret to use for obtaining the StorageOS
  API credentials. If not specified, default values will be attempted.

Create a `fast` storage class backed by StorageOS:

```yaml
cat > storageos-sc.yaml <<EOF
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
EOF
```

```
kubectl create -f storageos-sc.yaml
```

Verify the storage class has been created:

```bash
kubectl describe storageclass fast
Name:           fast
IsDefaultClass: No
Annotations:    <none>
Provisioner:    kubernetes.io/storageos
Parameters:     description=Kubernetes volume,fsType=ext4,pool=default
No events.
```

## 3. Create persistent volume claim

Create the PVC which uses the `fast` storage class:

```
cat > storageos-sc-pvc.yaml <<EOF
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
EOF
```

```
kubectl create -f storageos-sc-pvc.yaml
```

Verify the pvc has been created:

```bash
kubectl describe pvc fast0001
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
kubectl describe pv pvc-480952e7-f8e0-11e6-af8c-08002736b526
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

```
kubectl create -f storageos-sc-pvcpod.yaml
```

Verify that the pod has been created:

```bash
kubectl get pods
NAME                          READY     STATUS    RESTARTS   AGE
test-storageos-redis-sc-pvc   1/1       Running   0          44s
```
