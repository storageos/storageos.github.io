---
layout: guide
title: StorageOS Docs - OpenShift Pre-provisioned Volumes
anchor: install
module: install/openshift/preprovisioned
---

# Pre-provisioned Persistent Volumes

1. Create a volume using the StorageOS CLI or API.  Consult the
   [volume documentation]({% link _docs/manage/volumes/index.md %}) for details.

   ```bash
   # Create a volume with one replica.
   storageos volume create nginx-pv01 --label storageos.com/replicas=1

   default/nginx-pv01
   ```

1. Create the persistent volume `nginx-vol01`.

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
