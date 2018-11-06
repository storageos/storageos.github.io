---
layout: guide
title: StorageOS Docs - System Configuration
anchor: prerequisites
module: prerequisites/systemconfiguration
---

# System Configuration

StorageOS requires certain kernel modules to function, in particular [Linux-IO
](http://linux-iscsi.org/wiki/Main_Page), an open-source implementation of the
SCSI target.

We require the following modules to be loaded:

- `target_core_mod`
- `tcm_loop`
- `target_core_file`
- `configfs`

Depending on the distribution, the modules are sometimes shipped as part of the
base kernel package, and sometimes in a kernel extras package which requires
installation.

## Distribution Specifics

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

## Automatic Configuration

Once required kernel modules are installed on the system, for convenience we
provide a container which will ensure the appropriate modules are loaded and
ready for use at runtime. On Docker installations, you will need to run the
init container prior to starting StorageOS. Our installation guides for
Kubernetes and OpenShift include this step.

```bash
# Load the required kernel modules. The Kubernetes and OpenShift installations include this step.
docker run --name enable_lio                  \
           --privileged                       \
           --rm                               \
           --cap-add=SYS_ADMIN                \
           -v /lib/modules:/lib/modules       \
           -v /sys:/sys:rshared               \
           storageos/init:0.1
```

## Manual Configuration

For those wishing to manage their own kernel configuration, rather than using
the init container, perform the following steps:

- Ensure kernel modules are all loaded per list above
- Ensure configfs is loaded and mounted at /sys/kernel/config
