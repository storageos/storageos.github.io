---
layout: guide
title: StorageOS Docs - External Key/Value
anchor: operations
module: operations/external-kv
---

# External key-value store

StorageOS uses a key-value store to keep cluster metadata across the
distributed platform. The key-value backend can be `embedded` or `etcd`. The
`embedded` option is set by default and it enforces StorageOS to start internal
processes of etcd. The first 1 or 3 nodes that start StorageOS have an embedded
etcd server. The rest of the nodes act as etcd clients keeping consistency of
the cluster by communicating with the servers. The role of the embedded etcd
cannot be changed once a StorageOS container has started. Therefore, etcd
embedded is only recommended for testing and clusters with low amount of nodes
where zero config deployments are convenient.

&nbsp; <!-- this is a blank line -->

__It is recommended to use an external etcd cluster for production deployments__, where high
availability and fault tolerance are mandatory. To use an etcd cluster
provisioned and maintained outside the scope of StorageOS, StorageOS will
reference the etcd endpoint using env variables.

The specific env variables are (both are needed):

* `KV_BACKEND`: Set this to `etcd`
* `KV_ADDR`: Comma separated list of etcd targets, in the form host[:port].

&nbsp; <!-- this is a blank line -->

Etcd availability is mandatory for proper functioning of StorageOS. Relevant
operations such as create, mount, delete or unmount volumes require access to
the etcd cluster.

When using an external `etcd`, the user must maintain the availability and
integrity of the etcd cluster, so StorageOS can use it as a service.

It is highly recommended to keep the cluster backed up and ensure high availability
of its data. It is also important to keep the latency between StorageOS nodes
and the etcd replicas low. Deploying an etcd cluster in a different datacenter
or region can make StorageOS detect etcd nodes as lost because of latency.

> It is out of the scope of StorageOS to maintain the integrity and availability of the etcd
> cluster. The user must ensure a proper function of that cluster. However,
> StorageOS will try its best to mitigate, for as long as possible, any etcd
> outage. Volumes mounted will keep working and read-write operations will keep
> operating as normal.

&nbsp; <!-- this is a blank line -->

# Suggested Deployment Models

> According to the StorageOS installation procedure, the examples might differ.
> The following examples are available for both Kubernetes and Openshift.

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

