---
layout: guide
title: StorageOS Docs - Support
anchor: introduction
module: introduction/support
---

# Support

There are several ways to reach us if you require support. The fastest way to
get in touch is to [join our public Slack
channel.](https://slack.storageos.com) <script async defer
src="http://slack.storageos.com/slackin.js"></script>

You can file a support ticket via email to [
support@storageos.com](mailto:support@storageos.com), or file bugs against
specific components on the [StorageOS Github
repos](https://github.com/storageos).

To help us provide effective support, we request that you provide as much
information as possible when contacting us. The list below is a suggested
starting point. Additionally, please include anything specific, such as log
entries, that may help us debug your issue.


## Platform
- Cloud provider/Bare metal
- OS distribution and version
- Kernel version
- docker version and installation procedure (distro packages or docker install)

## StorageOS 
- Version of StorageOS
- `storageos node ls`
- `storageos volume ls`
- `storageos volume inspect VOL_ID # in case of issues with a specific volume`

## Orchestrator related (Kubernetes, OpenShift, etc)
- Version and installation method
- Managed or self managed?
- `kubectl -n storageos get pod` 
- `kubectl -n storageos logs -lapp=storageos -c storageos`
- `kubectl -n storageos get storageclass`
- Specific for your namespaces: `kubectl describe pvc PVC_NAME` 
- Specific for your namespaces: `kubectl describe pod POD_NAME` 

