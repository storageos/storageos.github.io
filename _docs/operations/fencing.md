---
layout: guide
title: StorageOS Docs -  Fencing Pods
anchor: operations
module: operations/fencing
---

# Fencing

For information regarding the fencing feature please see our
[Fencing](/docs/concepts/fencing) concepts page.

## Enabling StorageOS to fence a pod

In order to allow StorageOS to fence a pod scheduled on an unavailable node, a
pod must have the following:

* `storageos.com/fenced=true` label
* At least one StorageOS volume mounted
* Each StorageOS volume the pod mounts must have at least one healthy replica.
* Fencing is not disabled across the StorageOS cluster - `DISABLE_FENCING` environment
  variable is not set to true

> N.B. Any pod that is to be fenced must meet the criteria above

A pod created by the StatefulSet manifest below would be able to be fenced. The
pod has the `storageos.com/fenced=true` label, mounts a StorageOS volume - `vol`
and the StorageOS volume has a replica. Note that volumeClaimTemplates inherit
labels from the StatefulSet i.e. the replica label.

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: debian-stateful
spec:
  selector:
    matchLabels:
      app: "debian-stateful"
      storageos.com/fenced: "true"
      storageos.com/replicas: "1"
  serviceName: "default"
  replicas: 1
  template:
    metadata:
      labels:
        app: "debian-stateful"
        storageos.com/fenced: "true"
        storageos.com/replicas: "1"
    spec:
      containers:
      - name: debian
        image: debian:9-slim
        command: ["/bin/sleep"]
        args: [ "3600" ]
        volumeMounts:
        - name: vol
          mountPath: /mnt
  volumeClaimTemplates:
  - metadata:
      name: vol
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: "fast" # StorageOS storageClass
      resources:
        requests:
          storage: 1Gi
```

## Disable Fencing

Although fencing is enabled in a StorageOS cluster by default, pods will not be
fenced unless the conditions above are met.

However, to completely disable fencing in a StorageOS cluster the environment variable
`DISABLE_FENCING=true` can be set.
