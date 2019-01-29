---
layout: guide
title: StorageOS Docs - DockerEE
anchor: platforms
module: platforms/dockeree/install
---

# DockerEE

This section of documentation covers the use of StorageOS in Docker Enterprise Edition.

DockerEE and the Universal Control Plane can be executed in different Linux
distributions. StorageOS supports RHEL, CentOS, Debian, and selected Ubuntu
images. For more details, check out the supported OS in the [prerequisites page]({%link _docs/prerequisites/systemconfiguration.md %}).

StorageOS supports only Kubernetes nodes managed by Docker Enterprise Edition.
Therefore, StorageOS volumes can be provisioned and used only by applications
on those nodes.

> Mixed nodes support is experimental
