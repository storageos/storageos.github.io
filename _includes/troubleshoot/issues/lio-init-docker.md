## LIO Init:Error

### Issue:

StorageOS init container failure log.
```bash
~# {{ page.cmd }} logs enable-lio
Checking configfs
configfs mounted on sys/kernel/config
Module target_core_mod is not running
executing modprobe -b target_core_mod
Module tcm_loop is not running
executing modprobe -b tcm_loop
modprobe: FATAL: Module tcm_loop not found.
```

### Reason:
It indicates that since the Linux open source SCSI drivers are not enabled, StorageOS cannot start.


### Solution:
Install the kernel modules (usually found in the `linux-image-extra-$(uname -r)` package of your distribution) in your nodes following this [prerequisites page]({%link
_docs/prerequisites/systemconfiguration.md %}) and delete StorageOS pods, so the DaemonSet creates the pods again.

The logs of the container indicate which kernel modules couldn't be loaded or that they are not properly configured:
