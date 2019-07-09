---
layout: guide
title: TCMU reference
anchor: reference
module: reference/tcmu
---

# TCMU

TCM is another name for LIO, an in-kernel iSCSI target (server).
Existing TCM targets run in the kernel.  TCMU (TCM in Userspace) allows
userspace programs to be written which act as iSCSI targets.

In addition, it modularises the transport protocol used for carrying SCSI
commands ("fabrics"), the Linux kernel target, LIO, also modularizes the actual
data storage as well. These are referred to as "backstores" or "storage
engines". StorageOS implements a backend backstore that is exported by TCMU as
a SCSI LUN.

The target serves as a translator that allows StorageOS to use standard
protocols while running in the userspace. Since LIO is entirely kernel code,
versatility and compatibility is gained by using TCMU.

TCMU combines with the LIO loopback fabric to become something similar to FUSE
(Filesystem in Userspace), but at the SCSI layer instead of the filesystem
layer. Therefore, StorageOS gains in performance, throughput and latency.

For more information about TCMU check the [kernel design
doc](https://www.kernel.org/doc/Documentation/target/tcmu-design.txt).

## Kernel compatibility

StorageOS uses TCMU when available. Otherwise it automatically reverts back to use FUSE. The
TCMU libraries needed are present in most modern compiled kernels, however
every Linux distribution have its own package policy. As follows, the list of
major distributions and its compatibility.

### Standard distributions

- RHEL 7 and 8: full support by default.
- CentOS 7: full support by default.
- Ubuntu 18: requires install the package `linux-image-extra` for full support.
  > Check the [system configuration preequisites page]({% link
  _docs/prerequisites/systemconfiguration.md %}) for more information.
- Ubuntu 16: requires install the package `linux-image-extra` for LIO, but TCMU
  is not available.

### AWS

- AWS Linux2: LIO supported by default, but TCMU not available.
  > StorageOS will use FUSE by default.

- Ubuntu 18 aws optimised kernel: not supported. 
  > For full supported Ubuntu use
  > the generic kernel. Check out [system configuration preequisites 
  > page]({% link _docs/prerequisites/systemconfiguration.md %}) for more information.

- Ubuntu 16 aws optimised kernel: not supported. 
  > For supported Ubuntu with LIO,
  > but not TCMU use the generic kernel. Check out [system configuration
  > preequisites page]({% link _docs/prerequisites/systemconfiguration.md %}) for
  > more information.

### Azure
- Ubuntu: full support by default.

### GKE
- Ubuntu 18 gke optimised kernel: full support by default.
- Ubuntu 16 gke optimised kernel: not supported. 
  > Kernel modules for LIO not available.

### DigitalOcean
- Ubuntu 18: requires install the package `linux-image-extra` for full support.
  > Check the [system configuration preequisites 
  > page]({% link _docs/prerequisites/systemconfiguration.md %}) for more information.
- Ubuntu 16: requires install the package `linux-image-extra` to have LIO, but
  TCMU is not available.
