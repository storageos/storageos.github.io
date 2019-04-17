---
layout: guide
title: StorageOS Docs - External Etcd
anchor: operations
module: operations/external-etcd
---

# External key-value store

StorageOS uses a key-value store to hold cluster metadata across the
distributed platform. The key-value backend can be `embedded` or `etcd`.

The `embedded` option is the default for ease of deployment and in this mode
StorageOS uses an internal etcd cluster. For testing that approximates a
real life workload we recommend the use of external etcd.

When using `embedded` etcd, the first StorageOS nodes that start, either the
first node or first three nodes, act as etcd servers. This is done in order to
establish
[quorum](https://en.wikipedia.org/wiki/Quorum_(distributed_computing)). The
rest of the nodes act as etcd clients, keeping consistency of the cluster by
communicating with the etcd servers. Whether a StorageOS node acts as an etcd server
or client cannot be changed once a StorageOS container has started.

&nbsp; <!-- this is a blank line -->

__It is recommended to use an external etcd cluster for production deployments__. To
use an etcd cluster provisioned and maintained outside the scope of StorageOS,
StorageOS will locate the etcd endpoint using environment variables. When
performing an installation using the StorageOS cluster operator these variables can be
set in the [StorageOSCluster resource definition](
/docs/reference/cluster-operator/configuration). Installations using the Helm
chart can set the variables in the [values.yaml
](https://github.com/storageos/charts/blob/master/stable/storageos/values.yaml)
file.

Manual installations with the yaml manifests found in our `deploy`
[repository](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/standard)
requires that two specific environment variables are set in the
[daemonset](https://github.com/storageos/deploy/blob/master/k8s/deploy-storageos/standard/manifests/040_daemonset.yaml_template).

* `KV_BACKEND`: Set to `etcd`
* `KV_ADDR`: Comma separated list of etcd targets, in the form host[:port].

&nbsp; <!-- this is a blank line -->

Etcd availability is mandatory for proper functioning of StorageOS. In
particular, changes to the cluster; creation/deletion of volumes,
adding/removing replicas e.g., require access to the etcd cluster. In the event
that etcd becomes unavailable, StorageOS clusters become read only, allowing
access to data but preventing metadata changes.

When using an external `etcd`, the user must maintain the availability and
integrity of the etcd cluster, so StorageOS can use it as a service.

It is highly recommended to keep the cluster backed up and ensure high availability
of its data. It is also important to keep the latency between StorageOS nodes
and the etcd replicas low. Deploying an etcd cluster in a different data center
or region can make StorageOS detect etcd nodes as unavailable because of latency.

*StorageOS cannot be held responsible for supporting an external etcd cluster.*

&nbsp; <!-- this is a blank line -->

# Suggested Deployment Models

> Depending on the orchestrator used, methods of passing environment variables
> to StorageOS containers differ. The following examples work with both
> Kubernetes and Openshift.

## Etcd cluster-operator
Etcd can be deployed in Kubernetes using the official [etcd-operator](
https://github.com/coreos/etcd-operator).

Examples of deploying etcd clusters using the etcd-operator on
[Kubernetes](
https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/etcd-as-svc)
and
[OpenShift](https://github.com/storageos/deploy/tree/master/openshift/deploy-storageos/etcd-as-svc)
are available.

The official etcd-operator repository also has a backup deployment operator
that can help backup etcd data. Make sure you take frequent backups of
the etcd cluster as it holds all the StorageOS cluster metadata.

## External etcd

To deploy StorageOS on a Kubernetes cluster using an etcd cluster running
outside Kubernetes, you can look at the following
[repository](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/external-etcd),
where etcd endpoints are referenced using a Kubernetes external service.

