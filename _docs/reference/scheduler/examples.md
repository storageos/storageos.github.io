---
layout: guide
title: StorageOS Docs - StorageOS Scheduler
anchor: reference
module: reference/scheduler/examples
---

# Scheduler Examples


## Scheduling modes

There are two modes available to enforce pod locality for StorageOS Volumes.
The mode is defined by labeling the Pods.


## Labels

{% include scheduler/locality-labels-table.md %}

## Preferred (Default)

The Pod will be placed along with its data if possible. Otherwise, it will be
placed along the volume replicas. If both scenarios are not possible, the Pod
will start on a different node and StorageOS will grant accessibility to the
data via network.

You can explicitly guarantee that mode by setting the label
`storageos.com/locality: "preferred"`to the Pod.

For instance a Pod would set the labels as:

```bash
apiVersion: v1
kind: Pod
metadata:
  name: pod
  labels:
    storageos.com/locality: "preferred"
spec:
  containers:
    - name: debian
      image: debian:9-slim
      command: ["/bin/sleep"]
      args: [ "3600" ]
      volumeMounts:
        - mountPath: /mnt
          name: v1
  volumes:
    - name: v1
      persistentVolumeClaim:
        claimName: persistent-volume # ----> StorageOS PVC
```

## Strict

The Pod will be enforced to be placed along its data. Hence, in the same node
as the Primary Volume. In case of that not being possible, the Pod will remain
in pending state until that premise is fulfilled.

You can enable this mode by setting the label `storageos.com/locality:
"strict"` to the Pod.

For instance an StatefulSet would set the labels as:

```bash
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  selector:
    matchLabels:
      app: mysql
      storageos.com/locality: "strict"   # Matching label to the template
  serviceName: mysql
  replicas: 1
  template:
    metadata:
      labels:
        app: mysql
        storageos.com/locality: "strict" # Inherited label by the Pod
    spec:
      serviceAccountName: mysql
      containers:
      - name: mysql
        image: mysql:5.7
...
  volumeClaimTemplates:
  - metadata:
      name: data
      labels:
        app: mysql
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: "storageos" # StorageClass for your cluster
      resources:
        requests:
          storage: 50Gi
```



## Explicit SchedulerName

> It is not necessary to explicitly set the SchedulerName as the [Admission
> Controller]({% link _docs/reference/scheduler/admission-controller.md %})
> automatically populates the PodSpec field. Set the SchedulerName in your
> manifests, manually, only if you disable or can't execute the StorageOS
> Admission Controller.

{% include scheduler/spec-example.md %}
