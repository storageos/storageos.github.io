---
layout: guide
title: StorageOS Docs - Production deployments
anchor: concepts
module: concepts/production
---

# Production deployments

## External key-value store

StorageOS uses a key-value store to store cluster configuration. For ease of use, etcd is embedded into the container image.

If you run Kubernetes using an external etcd cluster for high availability, you
may choose to use the same etcd cluster for StorageOS, which you can set by
configuring environment variables.

## Deploying compute-only nodes

As your cluster scales, you may wish to reserve specific nodes for storage and
other nodes for application workloads.

By default, StorageOS nodes both present and consume storage
(`storageos.com/deployment=mixed`). You can set
`storageos.com/deployment=computeonly` to specify that this node only consumes
storage.

# Rules

Rules apply custom configuration to volumes based on matched labels.

## Overview

Rules are used for managing data policy and placement using StorageOS features
such as replication, QoS and compression.

Rules are created using labels and selectors
to evaluate which StorageOS features to apply.

Rules are evaluated when a volume is created. If the selector is satisfied, the
labels are applied to the new volume.
