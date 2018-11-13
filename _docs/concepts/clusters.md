---
layout: guide
title: StorageOS Docs - Clusters
anchor: concepts
module: concepts/clusters
---

# Clusters

StorageOS clusters represent groups of nodes which run a common distributed
control plane, and aggregate their storage into one or more [pools]({% link
_docs/concepts/pools.md %}).

Typically, a StorageOS cluster maps one-to-one to a Kubernetes (or similar
orchestrator) cluster, and we expect our container to run on all of the worker 
nodes within that cluster.

Clusters use etcd to maintain state and manage distributed consensus between
nodes. We offer a choice between an internally managed etcd suitable for test
deployments, or the ability to interface with an external etcd, suitable for
production deployments.
