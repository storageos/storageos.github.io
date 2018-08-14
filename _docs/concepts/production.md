---
layout: guide
title: StorageOS Docs - Production deployments
anchor: concepts
module: concepts/production
---

# Production deployments

## External key-value store

StorageOS uses a key-value store to store cluster configuration. For ease of
use, etcd is embedded into the container image.

If you run Kubernetes using an external etcd cluster for high availability, you
may choose to use the same etcd cluster for StorageOS, which may be more stable
than using the internal embedded etcd.

## Deploying compute-only nodes

As your cluster scales, you may wish to reserve specific nodes for storage and
other nodes for application workloads.

By default, StorageOS nodes both present and consume storage
 (`storageos.com/deployment=mixed`). You can specify that a node should only
 consume storage by setting the `storageos.com/deployment=computeonly` label.

## Rules

Rules are used for managing data policy and placement using StorageOS features
such as replication, QoS and compression.

Rules are defined using labels and selectors. When a volume is created, the
rules are evaluated to determine whether to apply the action.

An example business requirement might be that all production volumes are
replicated twice. This would be defined with a selector `env==prod`, and the
action would be to add the label `storageos.com/replicas=2`.
