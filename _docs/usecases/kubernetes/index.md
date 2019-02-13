---
layout: guide
title: StorageOS Docs - Install applications on Kubernetes
anchor: usecases
module: usecases/kubernetes/examples
---

# Kubernetes

StorageOS can be used to provide permanent storage for other applications
running in [Kubernetes](https://kubernetes.io) or other Orchestrators that are
derived from Kubernetes such as [OpenShift](https://openshift.com) or
[Rancher](https://rancher.com). This is useful for running stateful
applications, such as databases or CI/CD applications, under the control of
Kubernetes as Kubernetes can make scheduling decisions withoutthe application
data being lost.

What we have outlined in the cookbooks below are some quick deployments of
stateful applications into a Kubernetes cluster. These examples are not
production ready but have been provided to give you some insight into how to
use StorageOS with stateful applications.

## StatefulSets

The examples we have provided use
[StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
as a way to deploy applications into Kubernetes. The reason for this is that
the StatefulSet controller is designed to manage stateful applications and it
"provides guarantees about the ordering and uniqueness" of sets of pods.

Practically this means that when a StatefulSet scales, pods are created in
order from 0-(N-1), if a StatefulSet scales down then pods are deleted in
reverse order from (N-1)-0.

Secondly, it means that the behaviour of the StatefulSet controller differs
from that of Deployment and ReplicaSet controllers. For Deployment and
ReplicaSet controllers "... at many points in the lifetime of a replica set
there will be 2 copies of a pod's processes running concurrently". Having two
different pods mount a volume at the same time can cause corruption of data.
Currently Kubernetes accessModes only apply restrictions to nodes mounting
volumes rather than pods, so it is important that StatefulSets are used with
StorageOS volumes so the necessary pod uniqueness guarantees are maintained.

### StatefulSet Manifests

The StorageOS specific part of the Kubernetes manifests for these examples lies
in the VolumeClaimTemplate that's part of the statefulset definition. 

VolumeClaimTemplate 
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mssql
spec:
  selector:
    matchLabels:
      app: mssql
      env: prod
  serviceName: mssql
  replicas: 1
  template:
    metadata:
      labels:
        app: mssql
        env: prod
    spec:
      serviceAccountName: mssql
      containers:
      - name: foo
        image: bar
        volumeMounts:
          - name: baz
            mountPath: /var/opt/bar
        envFrom:
        - configMapRef:
            name: mssql
  volumeClaimTemplates:
  - metadata:
      name: baz
      labels:
        env: prod
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: "fast" # StorageOS storageClass 
      resources:
        requests:
          storage: 5Gi

```
In the StatefulSet definition above the container has a volume mount
defined called baz. The definition for this volume is found in the
VolumeClaimTemplate where the fast storageClass will be used to dynamically
provision storage if the persistent volume does not already exist.
