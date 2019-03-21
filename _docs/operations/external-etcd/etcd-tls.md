---
layout: guide
title: StorageOS Docs - etcd TLS
anchor: operations
module: operations/external-etcd/etcd-tls
---

# Encrypting Communication with etcd

StorageOS supports secure communication with an external etcd cluster using
mutual TLS. With mutual TLS both StorageOS and etcd authenticate each other
ensuring that communication only happens between mutually authenticated end
points.

StorageOS uses environment variables to specify the location of the necessary
certificates and keys. The decision to use file paths instead of the actual
certificate values was taken to prevent accidentally leaking the values. It is
therefore required that Kubernetes secrets containing the certificates and keys
are mounted as volumes into the StorageOS container and environment variables
contain the file paths to the files from the secrets.

## Setting up mTLS with etcd

>In order to setup mTLS it is recomended that the CoreOS etcd operator is used
>and the CoreOS guide for [Cluster
>TLS](https://github.com/coreos/etcd-operator/blob/master/doc/user/cluster_tls.md)
>is followed. You can find a worked example of setting up etcd and StorageOS
>with TLS here(Link to deploy repo)

Once a TLS enabled etcd cluster is running a secret with the Certificate
Authority (CA) certificate, a client certificate and the client key needs to be
created. The filenames used to create the secret become the key names in the
secret. These filesnames need to be passed as part of the full file path to the
StorageOS TLS variables.

```bash
# Create the secret
$ kubectl create secret generic etcd-client-tls -n storageos \
  --from-file=etcd-client-ca.crt                             \
  --from-file=etcd-client.crt                                \
  --from-file=etcd-client.key

# Describe the secret to show key:value pairs
$ kubectl -n storageos describe secret etcd-client-tls
Name:         etcd-client-tls
Namespace:    storageos
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
etcd-client.key:     227 bytes
etcd-client-ca.crt:  790 bytes
etcd-client.crt:     798 bytes
```
> The secret should be created in the namespace that StorageOS will be
> installed into

Once the `etcd-client-tls` secret has been created it needs to be mounted into
the pod. The path to each file mounted into the pod from the secret needs to be
passed as an environment variable as in the table below.

| Environement Variable | Value                         |
| :------------------   | :---------------------------- |
| TLSEtcdCA             | /etc/pki/etcd-client.key      |
| TLSEtcdClientCert     | /etc/pki/etcd-client-ca.crt   |
| TLSEtcdClientKey      | /etc/pki/etcd-client.crt      |

These environment variables can be passed in the daemonset manifest or as part
of a configMap. Below you can see an example of a configMap passing the
required environment variables to the StorageOS container. The configMap also
contains the environment variables `KV_BACKEND` and `KV_ADDR` that tell
StorageOS that an external key:value store will be used and the URL to use to
find the store (see [External etcd](/docs/operations/external-etcd)). The URL
in this case is that of a Kubernetes service that points to an etcd cluster.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: storageos-config
  namespace: storageos
data:
  KV_BACKEND: 'etcd'
  KV_ADDR: 'https://storageos-etcd-cluster-client.etcd.svc:2379'
  TLS_ETCD_CA: '/etc/pki/etcd-client-ca.crt'
  TLS_ETCD_CLIENT_CERT: '/etc/pki/etcd-client.crt'
  TLS_ETCD_CLIENT_KEY: '/etc/pki/etcd-client.key'
---
kind: DaemonSet
apiVersion: apps/v1
metadata:
  name: storageos
  namespace: storageos
spec:
  template:
    metadata:
      name: storageos
      labels:
        app: storageos
    spec:
      containers:
      - name: storageos
        envFrom:
        - configMapRef:
            name: storageos-config
        volumeMounts:
          - name: etcd-certs
            mountPath: /etc/pki
            readOnly: true
      volumes:
      - name: etcd-certs
        secret:
          secretName: etcd-client-tls
```
