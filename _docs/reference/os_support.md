---
layout: guide
title: StorageOS Docs - OS support
anchor: reference
module: reference/ossupport
---

# OS support

StorageOS uses FUSE known as a Filesystem in Userspace. It is a software interface for Unix-like computer operating systems that lets non-privileged users create their own file systems without editing kernel code. In addition, StorageOS is developed using Linux-IO (LIO) Target. An open-source implementation of the SCSI target.
However, LIO is supported by most of the kernels available nowadays, some distributions have left the kernel module out of the main kernel package.


## Distribution support

The following table shows which distributions can enable the kernel modules to use LIO, weather needed to install linux-virtual-extra or not.

| Distribution               | Can use LIO? | Comments                                                           |
| ---                        | :---:        | ---                                                                |
| RHEL 7.5                   | Yes          |                                                                    |
| CentOS 7                   | Yes          |                                                                    |
| Ubuntu 16.04/18.04 Generic | Yes          | Requires installation of linux-image-extra-$(uname -r) package     |
| Ubuntu 16.04/18.04 AWS     | No           | There is no linux-image-extra candidate for AWS optimised kernel   |
| Ubuntu 16.04/18.04 Azure   | No           | There is no linux-image-extra candidate for Azure optimised kernel |
| Ubuntu 16.04 GCE           | Yes          | Requires installation of linux-image-extra-$(uname -r) package     |
| Ubuntu 18.04 GCE           | No           | There is no linux-image-extra candidate for GCE optimised kernel   |
| Debian 9                   | Yes          |                                                                    |


## How to enable LIO support

The following script will try to load the modules in your host. If it finishes without error, your OS is compatible and LIO support will be enabled.

It requires privileged permissions.

```
cat <<'END' > verify_os.sh
#!/bin/bash
 
set -e
 
if mount | grep -q "^configfs on /sys/kernel/config"; then
    echo "configfs mounted on sys/kernel/config"
else
    echo "configfs not mounted, checking if kmod is loaded"
    if lsmod | grep -q configfs; then
        echo "configfs mod is loaded"
    else
        echo "configfs not loaded, executing: modprobe -b configfs"
        modprobe -b configfs
        if mount | grep -q configfs; then
            echo "configfs mounted"
        else
            echo "mounting configfs /sys/kernel/config"
            mount -t configfs configfs /sys/kernel/config
        fi
    fi
fi
 
target_dir=/sys/kernel/config/target
core_dir="$target_dir"/core
loop_dir="$target_dir"/loopback
 
# Check if kernel modules have been enabled before
if [ -d $target_dir ] &&
   [ -d $core_dir ]   &&
   [ -d $loop_dir ];
   then
    echo "LIO already set up"
    exit 0
fi
 
# Check kernel modules, one by one and enable if the previous
# prerequisite succeeded
if [ -d "$target_dir" ]; then
    echo "LIO target is present"
else
    echo "LIO target not present, executing: modprobe -b target_core_mod"
    modprobe -b target_core_mod
fi
 
if [ -d "$core_dir" ]; then
    echo "Executing: modprobe -b tcm_loop"
    modprobe -b tcm_loop
    sleep 2

    if [ -d $loop_dir ]; then
        echo "$loop_dir exists"
    else
        echo "$loop_dir didn't exist. Creating dir manually..."
        mkdir $loop_dir
    fi

    echo "Executing: modprobe -b target_core_file"
    modprobe -b target_core_file
else
    echo "/sys/kernel/config/target/core doesn't exist"
    exit 1
fi

echo "LIO set up is ready!"

END

chmod +x verify_os.sh
sudo ./verify_os.sh
```

## Ubuntu generic and GCE

It is required to install linux-image-extra for any generic ubuntu. 

Google Cloud Engine has got a candidate to install linux-image-extra with gce optimisation for Ubuntu 16.04. However, Ubuntu 18.04 doesn't have a package for it. 

```
sudo apt -y update
sudo apt -y install linux-image-extra-$(uname -r)
```

## Why there is no support for Ubuntu (AWS, Azure)
Canonical has created Ubuntu images for cloud providers with optimised versions of the kernel. These versions don't include the kernel modules needed by LIO and the linux-image-extra, where the modules are found in the generic image, doesn't have a candidate for the optimised version of the kernels.

You can check if linux-image-extra is available in the repositories.
```
sudo apt -y update && apt search linux-image-extra-$(uname -r)
```

It is possible to use Ubuntu with the mentioned cloud providers, however, it is recommended to use other distributions such as Debian, CentOS or RHEL.

To be able to use Ubuntu, it is necessary to change the kernel installed in your machine. Note that you will no longer use the performance optimisations Canonical has put in place for cloud providers.

```
sudo apt -y update
sudo apt install -y linux-virtual linux-image-extra-virtual
sudo apt purge -y linux*aws

# Reboot the machine
sudo shutdown -r now
```

