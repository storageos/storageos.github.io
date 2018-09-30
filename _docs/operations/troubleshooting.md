---
layout: guide
title: StorageOS Docs - Troubleshooting installation
anchor: operations
module: operations/troubleshooting
---

# Troubleshooting

Examples of common misconfigurations specific for platforms can be found in its own Troubleshooting section.

- [Kubernetes]({%link _docs/platforms/kubernetes/troubleshoot/index.md %})
- [Openhift]({%link _docs/platforms/openshift/troubleshoot/index.md %})
- [Docker]({%link _docs/platforms/docker/troubleshoot/index.md %})


# Submit a support case
StorageOS team handles support requests. To be able to assist you promptly and effectively it is best to provide as much information as possible. This is relevant information you can send in addition to a support request when having any issue or unexpected behaviour. 

## StorageOS 
- Version of StorageOS
- `storageos node ls`
- `storageos volume ls`
- `storageos volume inspect VOL_ID # in case of issues with an specific volume`

## Orchestrator related (Kubernetes, OpenShift, etc)
- Version and installation method
- Managed or self managed?
- `kubectl -n storageos get pod` 
- `kubectl -n storageos logs -lapp=storageos -c storageos`
- `kubectl -n storageos get storageclass`
- Specific for your namespaces: `kubectl describe pvc PVC_NAME` 
- Specific for your namespaces: `kubectl describe pod POD_NAME` 

## Common
- Cloud provider/Bare metal
- OS distribution and version
- Kernel version
- docker version and installation procedure (distro packages or docker install)

# Reuse nodes for a new StorageOS cluster

{% include troubleshoot/issues/newcluster-old-nodes.md %}
