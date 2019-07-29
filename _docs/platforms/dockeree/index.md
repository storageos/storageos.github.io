---
layout: guide
title: StorageOS Docs - DockerEE
platform: dockeree
platform-pretty: "DockerEE"
anchor: platforms
module: platforms/dockeree
---

# Docker EE

This section of documentation covers the use of StorageOS in Docker Enterprise Edition.

Docker EE and the Universal Control Plane can run on different Linux
distributions. StorageOS supports RHEL, CentOS, Debian, and selected Ubuntu
images. For more details, check out the supported OS in the
[prerequisites page]({%link _docs/prerequisites/systemconfiguration.md %}).

StorageOS only supports Kubernetes nodes managed by Docker Enterprise Edition,
not those running Swarm. Mixed nodes (those running Kubernetes and Swarm
workloads)  are also not supported.  As a consequence, StorageOS volumes can
only be provisioned on Kubernetes nodes, and only these nodes should be used
for stateful workloads.

