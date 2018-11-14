---
layout: guide
title: StorageOS Docs - Supported Platforms
anchor: introduction
module: introduction/platforms
---

# Supported Platforms and Orchestrators

StorageOS runs on a variety of platforms and orchestrators. The following
sections detail these, and any known platform specific limitations.

## OS

- Linux X86_64
- Kernels satisfying our module [prerequisites]({% link _docs/prerequisites/systemconfiguration.md %})
- 3.x kernels have a limitation of 256 active volumes per node
- 4.x kernels have a limitation of 4096 active volumes per node
- We are distribution agnostic as long as our prerequisites are met

## Orchestrators

- Kubernetes 1.7+
- OpenShift 3.7+

