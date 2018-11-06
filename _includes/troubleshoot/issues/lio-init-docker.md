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

This error indicates that one or more kernel modules cannot be loaded because
they are not installed on the system.

### Solution:

Install the appropriate kernel modules (usually found in the `linux-image-extra-$(uname -r)` package of your distribution) on your nodes following this [prerequisites
page]({%link _docs/prerequisites/systemconfiguration.md %}) and delete
StorageOS pods, causing the DaemonSet to create the pods again.

The logs of the container indicate which kernel modules couldn't be loaded or
that they are not properly configured:
