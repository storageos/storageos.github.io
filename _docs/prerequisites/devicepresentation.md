---
layout: guide
title: StorageOS Docs - Device Presentation
anchor: prerequisites
module: prerequisites/devicepresentation
---

# Device presentation

StorageOS uses Linux-IO (LIO), an open-source implementation of
the SCSI target. It is mandatory to enable certain kernel module to use LIO.

To check whether a host can support the required kernel modules, run:

```bash
docker run --name enable_lio                  \
           --privileged                       \
           --rm                               \
           --cap-add=SYS_ADMIN                \
           -v /lib/modules:/lib/modules       \
           -v /sys:/sys:rshared               \
           storageos/init:0.1
```

which runs a [script to load the kernel modules](https://github.com/storageos/init/blob/master/enable-lio.sh). If the script results in an error, check the following table for whether you need to load extra packages:

| Distribution               | Can use LIO? | Requirements                                                           |
| ---                        | :---:        | ---                                                                |
| RHEL 7.5                   | Yes          |                                                                    |
| CentOS 7                   | Yes          |                                                                    |
| Ubuntu 16.04/18.04 Generic | Yes          | Requires installation of linux-image-extra-$(uname -r) package     |
| Ubuntu 16.04/18.04 AWS     | No           | There is no linux-image-extra candidate for AWS optimised kernel   |
| Ubuntu 16.04/18.04 Azure   | No           | There is no linux-image-extra candidate for Azure optimised kernel |
| Ubuntu 16.04 GCE           | Yes          | Requires installation of linux-image-extra-$(uname -r) package     |
| Ubuntu 18.04 GCE           | No           | There is no linux-image-extra candidate for GCE optimised kernel   |
| Debian 9                   | Yes          |                                                                    |

For Ubuntu and Ubuntu 16.04 GCE, install `linux-image-extra`:

```bash
sudo apt -y update
sudo apt -y install linux-image-extra-$(uname -r)
```

This package is not yet available for Ubuntu 18.04 on GCE.

## Why there is no support for Ubuntu (AWS, Azure)
Canonical created Ubuntu images for cloud providers with optimised versions of the kernel. These versions don't include the kernel modules needed by LIO and the linux-image-extra, where the modules are found in the generic image, doesn't have a candidate for the optimised version of the kernels.

You can check if linux-image-extra is available in the repositories.

```bash
sudo apt -y update && apt search linux-image-extra-$(uname -r)
```

It is possible to use Ubuntu with the mentioned cloud providers, however, it is recommended to use other distributions such as Debian, CentOS or RHEL.

To be able to use Ubuntu, it is necessary to change the kernel installed in your machine. Note that you will no longer use the performance optimisations Canonical has put in place for cloud providers.

```bash
sudo apt -y update
sudo apt install -y linux-virtual linux-image-extra-virtual
sudo apt purge -y linux*aws

# Reboot the machine
sudo shutdown -r now
```
