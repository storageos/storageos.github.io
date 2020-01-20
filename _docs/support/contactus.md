---
layout: guide
title: StorageOS Docs - Support
anchor: support
module: support/contact
redirect_from: /docs/introduction/support
---

# Support

There are several ways to reach us if you require support. The fastest way to
get in touch is to [join our public Slack
channel.](https://slack.storageos.com) <script async defer
src="http://slack.storageos.com/slackin.js"></script>

You can file a support ticket via email to [
support@storageos.com](mailto:support@storageos.com), or use our [Help Desk
portal](https://support.storageos.com)

To help us provide effective support, we request that you provide as much
information as possible when contacting us. The majority of the information
that we require can be sent automatically to StorageOS engineers by generating
a [StorageOS Cluster
Report](/docs/support/contactus#storageos-cluster-report).

## StorageOS Cluster Report

StorageOS has a cluster diagnostic function that aggregates cluster information.

For each node the following is collected:

- StorageOS logs
- output of `storageos inspect node`
- output of `lshw`
- output of `dmesg`

StorageOS engineers might ask for a report to be generated during
support cases.

The information given in the cluster report is only used for support purposes
and it will be removed once the data is no longer needed for such purposes.
In case the information is sensitive and can't be given to StorageOS, please
make sure that support engineers have as much information about your
environment as possible. The information required is contained in the list
below.

The cluster report is created only when a user chooses to do so. For
convenience the report can either be uploaded to StorageOS or downloaded from
the diagnostic API endpoint. The report is uploaded from a StorageOS node to a
StorageOS GCP encrypted bucket using a TLS encrypted connection. The upload
takes place only after user confirmation.

You can generate a report through the StorageOS [GUI](/docs/reference/gui) by
navigating to the `Cluster` menu. When you upload the cluster report through
the GUI please send us your clusterID so we can retrieve the cluster report.
The clusterID can be viewed in the GUI under `Cluster`, or `License` menus or retrieved
via the CLI.
```bash
{% raw %} storageos licence inspect -f '{{ .ArrayUUID  }}' {% endraw %}
```

## Manual Cluster Report Collection

You can also directly connect to the cluster diagnostic API endpoint and
retrieve the bundle. Note that only a user with the Admin role can create
Diagnostic Bundles.
```bash
curl -u <ADMIN_USERNAME>:<ADMIN_PASSWORD> http://<NODE_IP>:5705/v1/diagnostics/cluster -o diagnostic.tar
```

In certain circumstances the cluster report may not be available, for example
if StorageOS pods are failing to start. Under such circumstances the list below
is a suggested starting point for information to include in your support
request. Additionally, please include anything specific, such as log entries,
that may help us debug your issue.

### Logs
- StorageOS logs - located under /var/lib/storageos/logs from all nodes
- `dmesg` output
- `lshw` output

### Platform
- Cloud provider/Bare metal
- OS distribution and version
- Kernel version
- docker version and installation procedure (distro packages or docker install)

### StorageOS
- Version of StorageOS
- `storageos node ls`
- `storageos volume ls`
- `storageos volume inspect VOL_ID` # in case of issues with a specific volume
- Use of embedded or external etcd

### Orchestrator related (Kubernetes, OpenShift, etc)
- Version and installation method
- Managed or self managed?
- `kubectl -n storageos get pod` 
- `kubectl -n storageos logs -lapp=storageos -c storageos`
- `kubectl -n storageos get storageclass`
- Specific for your namespaces: `kubectl describe pvc PVC_NAME` 
- Specific for your namespaces: `kubectl describe pod POD_NAME` 

