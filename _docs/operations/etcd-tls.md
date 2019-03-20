---
layout: guide
title: StorageOS Docs - Etcd TLS
anchor: operations
module: operations/etcd-tls
---

# Encrypting Communication with Etcd

StorageOS supports secure communication with etcd using mutual TLS. With mutual
TLS both StorageOS and Etcd authenticate each other ensuring that communication
only happens between mutually authenticated end points.

StorageOS uses environment variables to know where the necessary
certificates and keys can be found. The decision to use file paths instead
of the actual values of the required certificates and keys was taken to prevent
accidentally leaking the values. It is therefore expected that Kubernetes
secrets will be mounted as volumes into the StorageOS container and the value
of the environment variables will reflect the file paths of the secrets.

## Setting up mTLS with Etcd

>In order to setup mTLS it is recomended that the CoreOS etcd operator is used
>and the CoreOS guide for [Cluster
>TLS](https://github.com/coreos/etcd-operator/blob/master/doc/user/cluster_tls.md)
>is followed. You can find a worked example of setting up etcd and StorageOS
>with TLS here(Link to deploy repo)

Once a TLS enabled etcd cluster is running a secret with the Certificate
Authority (CA) certificate, a Client certificate and the Client key needs to be
created. The filenames become the key names in the secret and the filenames
need to be passed, along with the full path to the file, to the StorageOS TLS
variables.

```bash
# Create the namespace that StorageOS will be installed into
$ kubectl create namespace storageos

# Create the secret in the newly created namepsace
$ kubectl create secret generic etcd-client-tls -n storageos --from-file=etcd-client-ca.crt --from-file=etcd-client.crt --from-file=etcd-client.key
```
> The secret should be created in the namespace that StorageOS will be
> installed into

Once the secret has been created the daemonset manifest needs to be edited so
that the `etcd-client-tls` secret is mounted into the pod. The path of each
file from the secret then needs to be passed to the environment variables in
the table below.

| Variable Name       | Expected Value                                 |
| :------------------ | :--------------------------------------------- |
| TLSEtcdCA           | File path to Certificate Authority Certificate |
| TLSEtcdClientCert   | File path to Etcd Client Certificate           |
| TLSEtcdClientKey    | File path to Etcd Client key                   |

