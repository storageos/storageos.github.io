---
layout: guide
title: StorageOS Docs - StorageOS Scheduler
anchor: reference
module: reference/scheduler/admission-controller
---

# Admission Controller

StorageOS implements a `MutatingAdmissionWebhook` [Admission
Controller](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#what-are-admission-webhooks)
to ensure that Pods using StorageOS Volumes use the [storageos-scheduler]({%
link _docs/reference/scheduler/index.md %}). An admission controller intercepts
requests to the Kubernetes API server prior to persistence of the object, but
after the request is authenticated and authorized.

The Admission Controller is responsible for mutating the PodSpec at creation time
to populate the `PodSpec.schedulerName` field with the name of the StorageOS
Scheduler - `storageos-scheduler`.

During Pod creation, Kubernetes sends a web request to the StorageOS
WebHook with the Pod specification. The PodSpec is only altered to use the
StorageOS scheduler if the Pod uses a StorageOS volume.

## Web Server

The Web Server hosting the web hook is executed in the StorageOS Cluster
Operator. Since only HTTPS requests are allowed, the Operator generates a
self-signed x509 certificate every time it starts. The Cluster Operator will
also renew certificates upon expiry (certs are valid for one year).

There is no manual intervention required regarding the SSL configuration as the
setup is completely transparent between StorageOS and Kubernetes.

## Skipping Mutation

To avoid scheduler mutation, the `storageos.com/scheduler=false` annotation can
be added to resources that use StorageOS volumes.

When using StatefulSets the annotation can be set on the `spec.template.metadata.annotations` field.

```yaml
apiVersion: apps/v1
kind: StatefulSet
spec:
  ...
  template:
    metadata:
      annotations:
        storageos.com/scheduler: "false" # N.B. the value must be a string and not a boolean
```

When using Pods the annotation is set on the `metadata.annotations` field.
```yaml
apiVersion: v1
kind: Pod
metadata:
    ...
    annotations:
        storageos.com/scheduler: "false" # N.B. the value must be a string and not a boolean
    ...
```


## Compatibility

The Admission Controller doesn't need to be enabled at Kubernetes cluster
bootstrap time because it is a `Dynamic Admission Controller`. Hence, any
cluster that has the `MutatingAdmissionWebhook` enabled is supported. Most
Kubernetes cluster enable the Webhook admission controller by default.

The
[MutatingAdmissionWebhook](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#mutatingadmissionwebhook)
is available from Kubernetes v1.13.

You can check your Kubernetes cluster compatibility by checking if the
following object exists.

```bash
kubectl api-versions | grep admissionregistration.k8s.io
```
