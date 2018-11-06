---
layout: guide
title: StorageOS Docs - External Key/Value
anchor: operations
module: operations/external-kv
---

# External key-value store

StorageOS uses a key-value store to keep cluster metadata across the
distributed platform. The key-value backend can be `embedded` or `etcd`. The
`embedded` option is our default for ease of deployment and in this mode we run
an internal etcd cluster. The first 1 or 3 nodes that start StorageOS act as
etcd servers, and the rest of the nodes act as etcd clients keeping consistency
of the cluster by communicating with the servers. The role of the embedded etcd
cannot be changed once a StorageOS container has started.  Therefore, embedded
etcd is only recommended for testing and clusters with low node counts where
zero config deployments are convenient.

&nbsp; <!-- this is a blank line -->

__It is recommended to use an external etcd cluster for production deployments__, where high
availability and fault tolerance are mandatory. To use an etcd cluster
provisioned and maintained outside the scope of StorageOS, StorageOS will
locate the etcd endpoint using environment variables.

The specific env variables are (both are needed):

* `KV_BACKEND`: Set this to `etcd`
* `KV_ADDR`: Comma separated list of etcd targets, in the form host[:port].

&nbsp; <!-- this is a blank line -->

Etcd availability is mandatory for proper functioning of StorageOS. In
particular, changes to the cluster (adding or removing volumes or replicas,
etc.) require access to the etcd cluster. In the event that etcd becomes
unavailable, StorageOS clusters become read only, allowing access to data but
preventing metadata changes.

When using an external `etcd`, the user must maintain the availability and
integrity of the etcd cluster, so StorageOS can use it as a service.

It is highly recommended to keep the cluster backed up and ensure high availability
of its data. It is also important to keep the latency between StorageOS nodes
and the etcd replicas low. Deploying an etcd cluster in a different datacenter
or region can make StorageOS detect etcd nodes as unavilable because of latency.

*StorageOS cannot be held responsible for supporting an external etcd cluster.*

&nbsp; <!-- this is a blank line -->

# Suggested Deployment Models

> Depending on the orchestrator used, ways of supplying environment variables
> to StorageOS containers differ. The following examples work with both
> Kubernetes and Openshift.

## Etcd cluster-operator
Etcd can be deployed in Kubernetes using the official [etcd-operator](
https://github.com/coreos/etcd-operator).

You can find an example on how to deploy the etcd cluster with 3 replicas along
a StorageOS installation procedure that uses that cluster in the following
[repository](
https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/etcd-as-svc).

The official etcd-operator repository also has a backup deployment operator
that comes in hand to keep your metadata persisted.
Make sure you keep frequent backups of the etcd cluster.

## External etcd

To deploy StorageOS on a Kubernetes cluster using an etcd cluster running
outside Kubernetes, you can look at the following
[repository](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/external-etcd).
Where etcd endpoints are referenced using a Kubernetes external Service.

