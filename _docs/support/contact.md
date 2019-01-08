---
layout: guide
title: StorageOS Docs - Support
anchor: support
module: support/contact
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

Information about the cluster can be automatically sent to StorageOS engineers
as mentioned in the section [StorageOS Cluster
Report](/docs/introduction/support#storageos-cluster-report).

## Platform
- Cloud provider/Bare metal
- OS distribution and version
- Kernel version
- docker version and installation procedure (distro packages or docker install)

## StorageOS 
- Version of StorageOS
- `storageos node ls`
- `storageos volume ls`
- `storageos volume inspect VOL_ID` # in case of issues with a specific volume

## Orchestrator related (Kubernetes, OpenShift, etc)
- Version and installation method
- Managed or self managed?
- `kubectl -n storageos get pod` 
- `kubectl -n storageos logs -lapp=storageos -c storageos`
- `kubectl -n storageos get storageclass`
- Specific for your namespaces: `kubectl describe pvc PVC_NAME` 
- Specific for your namespaces: `kubectl describe pod POD_NAME` 

## StorageOS Cluster Report

StorageOS has a cluster diagnostic function that aggregates cluster information.
For each node the following is collected:

- StorageOS logs
- output of `lshw`
- output of `storageos inspect node`

StorageOS engineers might ask for a report to be generated during
support cases.

The cluster report is created only when a user chooses to do so. The report
is uploaded from a StorageOS node to a StorageOS GCP encrypted bucket using a
TLS encrypted connection. The upload takes place only after user confirmation.
Furthermore, StorageOS engineers can only access an uploaded report when a
user contacts support and supplies the StorageOS cluster ID with which the
report is encrypted.

The information given in the cluster report is only used for support purposes
and it will be removed once the data is no longer needed for such purposes.
In case the information is sensitive and can't be given to StorageOS, please
make sure that support engineers have as much information about your
environment as possible.

You can generate a report through the StorageOS
[GUI]({%link _docs/reference/gui.md %}) by pressing the `cluster
diagnostics` button on the left menu.
