---
layout: guide
title: StorageOS Docs - Clusters
anchor: concepts
module: concepts/clusters
---

# Clusters

StorageOS clusters represent groups of nodes which run a common distributed
control plane, and aggregate their storage into one or more
[pools](/docs/concepts/pools).

Typically, a StorageOS cluster maps one-to-one to a Kubernetes (or similar
orchestrator) cluster, and we expect our container to run on all worker 
nodes within the cluster that will consume or present storage.

Clusters use etcd to maintain state and manage distributed consensus between
nodes. We offer a choice between an internally managed etcd suitable for test
installations or the ability to interface with an external etcd, suitable for
production deployments. We recommend the use of external etcd when production
or production like workloads will be deployed on StorageOS.
