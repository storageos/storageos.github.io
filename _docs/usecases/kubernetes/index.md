---
layout: guide
title: StorageOS Docs - Install applications on Kubernetes
anchor: usecases
module: usecases/kubernetes/examples
---

# Kubernetes

StorageOS can be used to provide permanent storage for other applications
running in [Kubernetes](https://kubernetes.io). This is useful for running
stateful applications, such as databases or CI/CD applications, under the
control of Kubernetes as Kubernetes can make scheduling decisions without
the application data being lost.

What we have outlined in the cookbooks below are some quick deployments of
stateful applications into a Kubernetes cluster. These examples are not
production ready but have been provided to give you some insight into how to
use StorageOS with stateful applications.

The examples we have provided use [Stateful sets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
as a way to deploy these applications. 

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
