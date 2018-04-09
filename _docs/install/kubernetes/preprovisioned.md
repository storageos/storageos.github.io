---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: install
module: install/kubernetes/preprovisioned
---

# Pre-provisioned Persistent Volumes

1. Create a volume using the StorageOS CLI or API.  Consult the
   [volume documentation]({% link _docs/manage/volumes/index.md %}) for details.

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
