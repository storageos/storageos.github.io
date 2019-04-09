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

StorageOS uses [environment variables](/docs/reference/envvars) to specify the
location of the necessary certificates and keys. This allows secrets to be
mounted as volumes, directly into pods.

## Setting up mTLS with etcd

In order to setup etcd with mTLS it is recommended that the CoreOS etcd
operator is used and the CoreOS guide for [Cluster
TLS](https://github.com/coreos/etcd-operator/blob/master/doc/user/cluster_tls.md)
is followed. You can find a worked example of setting up etcd and StorageOS
with TLS
[here](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/etcd-tls).

Once etcd has been setup with mTLS, the StorageOS operator can be used to
create a StorageOS cluster using the client certificates created during the
etcd setup. The operator uses the secret containing etcd client certificates to
create a secret in the StorageOS namespace that is then mounted into the
StorageOS pods.

Below is an example StorageOSCluster resource that can be used to setup
StorageOS with etcd using mTLS.

```yaml
apiVersion: storageos.com/v1
kind: StorageOSCluster
metadata:
  name: storageos-cluster
  namespace: "default"
spec:
  images:
    nodeContainer: "storageos/node:1.2.0"
  secretRefName: "storageos-api"
  secretRefNamespace: "default"
  namespace: "storageos"
  # External mTLS secured etcd cluster specific properties
  tlsEtcdSecretRefName: "etcd-client-tls"                          # Secret containing etcd client certificates
  tlsEtcdSecretRefNamespace: "etcd"                                # Namespace of the client certificates secret
  kvBackend:
    address: "https://storageos-etcd-cluster-client.etcd.svc:2379" # Etcd client service address.
    backend: "etcd"                                                # Backend type
```
