---
layout: guide
title: StorageOS Docs - Install applications on Kubernetes
anchor: usecases
module: usecases/kubernetes/examples
---

# Kubernetes

StorageOS can be used to provide persistent storage for other applications
running in [Kubernetes](https://kubernetes.) or other Orchestrators that are
derived from Kubernetes such as [OpenShift](https://openshift.com) and
[Rancher](https://rancher.com). This makes it possible to run stateful
applications, such as databases, message queues or CI/CD applications, under
the control of Kubernetes. As the storage persists the lifetime of the
application pod Kubernetes can make scheduling decisions about your application
pods without the application data being lost.

What we have outlined in these cookbooks are some quick deployments of
stateful applications into a Kubernetes cluster. These examples are not
production ready but have been provided to give you some insight into how to
use StorageOS with stateful applications.

## StatefulSets
All of the cookbooks we have provided use
[StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
as a way to deploy applications. This is because the StatefulSet is a Kubernetes controller
designed for managing stateful applications. The StatefulSet controller
guarantees that when a pod is rescheduled it binds the same PersistentVolume. This
ensures that storage for your StatefulSet managed pods is stable and
persistent.

The StorageOS specific part of the StatefulSet manifests for these examples lies
in the VolumeClaimTemplate that's part of the statefulset definition.

### VolumeClaimTemplate 
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
defined called `baz`. The definition for this volume is found in the
VolumeClaimTemplate where the fast storageClass will be used to dynamically
provision storage if the persistent volume does not already exist.
