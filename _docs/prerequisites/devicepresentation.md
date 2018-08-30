---
layout: guide
title: StorageOS Docs - Device Presentation
anchor: prerequisites
module: prerequisites/devicepresentation
---

# Device presentation

Certain kernel modules are required to use StorageOS, in particular Linux-IO
(LIO), an open-source implementation of the SCSI target. LIO support depends
on the operating system.

**RHEL 7.5, CentOS 7** and **Debian 9** are fully supported.

**Ubuntu 16.04/18.04 Generic** and **Ubuntu 16.04 GCE** require extra packages:

```bash
sudo apt -y update
sudo apt -y install linux-image-extra-$(uname -r)
```

**Ubuntu 16.04/18.04 AWS, Ubuntu 16.04/18.04 Azure** and **Ubuntu 18.04 GCE** do
*not yet provide the linux-image-extra package. You should either use Debian,
*CentOS or RHEL, or install the non-cloud-provider optimised Ubuntu kernel:

```bash
sudo apt -y update
sudo apt install -y linux-virtual linux-image-extra-virtual
sudo apt purge -y linux*aws

# Reboot the machine
sudo shutdown -r now
```

On Docker installations, you will need to run the init container on each host
to enable the kernel modules. The Kubernetes and OpenShift installations include
this step.

```bash
# Check if linux-image-extra is available in the repositories
sudo apt -y update && apt search linux-image-extra-$(uname -r)

# Load the required kernel modules. The Kubernetes and OpenShift installations include this step.
docker run --name enable_lio                  \
           --privileged                       \
           --rm                               \
           --cap-add=SYS_ADMIN                \
           -v /lib/modules:/lib/modules       \
           -v /sys:/sys:rshared               \
           storageos/init:0.1
```
