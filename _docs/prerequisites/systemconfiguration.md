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

* `target_core_mod`
* `tcm_loop`
* `target_core_file`
* `configfs`
* `target_core_user`
* `uio`

> N.B. Other applications utilising [TCMU](http://linux-iscsi.org/wiki/LIO)
> cannot be run concurrently with StorageOS. Doing so may result in corruption
> of data. On startup, StorageOS will detect if other applications are using
> TCMU and fall back to FUSE. However if StorageOS is started first there is no
> mechanism for StorageOS to fallback to FUSE if another application begins to
> use TCMU. TCMU can be disabled using the
> [DISABLE_TCMU](/docs/reference/cluster-operator/configuration)
> StorageOSCluster spec parameter.

Depending on the distribution, the modules are shipped as part of the
base kernel package or as part of a kernel extras package which needs to be
installed.

## Distribution Specifics

The following distributions are supported by default:
* RHEL 7.5
* CentOS 7
* Debian 9
* Ubuntu Azure
* RancherOS - Note CSI is not supported on RancherOS

Ubuntu 16.04/18.04 requires the installation of additional packages.

> N.B. Ubuntu 16.04/18.04 AWS and Ubuntu 18.04 GCE do not provide the
> necessary linux-image-extra package - [see
> below](/docs/prerequisites/systemconfiguration#ubuntu-on-aws-and-gce) for more information

## Ubuntu Package Installation

**Ubuntu 16.04/18.04 Generic** and **Ubuntu 16.04 GCE** require extra packages:

Ubuntu 16.04:

```bash
sudo apt -y update
sudo apt -y install linux-image-extra-$(uname -r)
```

Ubuntu 18.04+:

```bash
sudo apt -y update
sudo apt -y install linux-modules-extra-$(uname -r)
```

## Ubuntu With AWS Or GCE Kernels

**Ubuntu 16.04/18.04 AWS** and **Ubuntu 18.04 GCE** do not yet provide the
linux-image-extra package. As such you should either use **Debian**, **CentOS**
or **RHEL**, or install the non-cloud-provider optimised Ubuntu kernel.

Installing the non-cloud-provider optimised Ubuntu kernel is something that
should only be done with full understanding of potential ramifications.

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
           storageos/init:0.2
```

## Manual Configuration
For those wishing to manage their own kernel configuration, rather than using
the init container, perform the following steps:

* Ensure kernel modules are all loaded per list above
* Ensure configfs is loaded and mounted at /sys/kernel/config


## Shared FileSystem volumes

StorageOS ReadWriteMany volumes are implemented using a nfs-ganesha server over
StorageOS ReadWriteOnce volumes. To be able to mount nfs shares, the hosts
require that nfs client drivers are installed. StorageOS along with the kubelet
handle the volume mount. RHEL based distributions use the package `nfs-utils`
which is very often present with the default installation image, while Debian
family distributions require the package `nfs-common`.
