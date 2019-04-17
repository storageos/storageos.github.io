---
layout: guide
title: StorageOS Docs - Fencing
anchor: concepts
module: concepts/fencing
---

# High Availability for StatefulSets with Fencing

In order to understand what Fencing is and why it is a useful feature it's
important to understand the behaviour of StatefulSets.

## Kubernetes Default Node Failure Behaviour

Kubernetes does reschedule pods from some controllers when nodes become
unavailable. The default behaviour is that when a node becomes unavailable its
status becomes "Unknown" and after the pod-eviction-timeout has passed pods are
scheduled for deletion. By default, the pod-eviction-timeout is five minutes.

## StatefulSet Behaviour

StatefulSets are the de facto Kubernetes controller to use for stateful
applications. The StatefulSet controller offers guarantees around pod
uniqueness, sticky identities and the persistence of PVCs beyond the lifetime
of the pod. As such, StatefulSets have different characteristics and provide
different guarantees than Deployments.

Deployments guarantee the amount of healthy replicas by reconciling the state
of the cluster with the declared desired state. Attempts to align the cluster
state with the desired state happen as fast as possible by aggressively
initializing and terminating pods. If one pod is terminating, another will be
automatically scheduled to start even if the first pod is not yet completely
terminated. Stateless applications benefit from this behaviour as one pod
executes the same work as any other in the deployment.

StatefulSets, on the other hand, guarantee that every pod scheduled has a
unique identity, which is to say that only a single copy of the pod is running
in the cluster at any one time. Whenever scheduling decisions are made, the
StatefulSet controller ensures that only one copy of a pod is running. If a pod
is deleted, a new pod will not be scheduled until the first pod is fully
terminated. This is an important guarantee considering that FileSystems
need to be unmounted before they can be remounted in a new pod. Any PVC
defining a device requires this behaviour to ensure the consistency of the
data and thus the PVC.

As a consequence of the guarantee of unique pod identity, StatefulSet pods
don't get rescheduled upon node failures. This is because Kubernetes is unable to
reason about whether the node is temporarily unavailable due to a network
partition or if the node has crashed. Therefore, the StatefulSet controller
cannot guarantee that if it reschedules an unavailable pod that the pod is not
still running. The original pod would be running on the partitioned node and
the rescheduled pod would be running on a different node, in violation of the
StatefulSet guarantee of pod uniqueness. Instead, the StatefulSet controller
slates the pod on the partitioned node for termination, but since there is
no communication between the node and the control plane, the termination cannot
be actioned by the partitioned node. The control plane will then mark the pod
status as "Unknown" while it waits for the partition to heal or for a manual
intervention by the cluster operator. The partitioned node doesn't make any
changes to its pods as there's no communication between the node and the
Kubernetes control plane.

For more information on the rationale behind the design of StatefulSets please
see the Kubernetes design proposal for [Pod
Safety](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/storage/pod-safety.md)


## High Availability for StatefulSets with Fencing

_HA for StatefulSet applications can be achieved with the StorageOS Fencing
feature_.

StorageOS implements a feature known as Fencing. With Fencing, pods that are
scheduled on a failed node can be terminated by StorageOS allowing the pods to
be scheduled on a different node. StorageOS can determine if a pod should be
rescheduled by leveraging StorageOS health checks that are already used to
ensure high availability of data and failover. Without Fencing, the pod will be
slated for termination but this can only be actioned when the unavailable node
rejoins the cluster or the unavailable node is deleted from the cluster.

As explained in [StatefulSet
Behaviour](/docs/concepts/fencing#statefulset-behaviour), the StatefulSet
controller is conservative by design, given the constraints of various types of
persistent volumes that can be managed in Kubernetes. For certain workloads,
when StorageOS has declared a node offline it may be desirable to promote
faster pod rescheduling by allowing StorageOS to Fence pods on the unavailable
node. By enabling Fencing, StatefulSet pods have a much shorter time to recover
(TTR) than usual and no manual intervention is required for StatefulSet pods on
failed nodes to be rescheduled. Hence, _the combination of StorageOS volume
failover and StorageOS Fencing makes an application more resilient to node
failures with automatic recovery and a 30-60 second TTR._

## Why can StorageOS Fence Pods?

As a StorageOS pod runs on each node in the cluster that consumes or presents
storage, and these nodes communicate using a gossip protocol, StorageOS has
additional insight into whether a node cannot communicate with the master or if
the node is truly unavailable. Additionally due to the synchronous replication
of StorageOS volumes, any writes made to the volume on the partitioned node
will fail as the writes cannot be acknowledged by replica volumes. Therefore,
in a scenario where the node is unreachable StorageOS knows that the pod will
lose access to its data so it is safe for StorageOS to force the pod to be
rescheduled.

For more information about how to enable Fencing please see our [Fencing
Operations](/docs/operations/fencing) page. 
