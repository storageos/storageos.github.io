---
layout: guide
title: StorageOS Docs - Troubleshooting installation
anchor: install
module: install/troubleshooting
---

# Common installation problems and solutions

## Docker Managed Plugin

`/var/lib/storageos: no such file or directory`

```bash
$ sudo docker plugin install --alias storageos storageos/plugin
Plugin "storageos/plugin" is requesting the following privileges:
 - network: [host]
 - mount: [/var/lib/storageos]
 - mount: [/dev]
 - device: [/dev/fuse]
 - allow-all-devices: [true]
 - capabilities: [CAP_SYS_ADMIN]
Do you grant the above permissions? [y/N] y
latest: Pulling from storageos/plugin
dc0b5e834c01: Download complete
Digest: sha256:f25cb773c0c3172764f315df36b1657f168533a49ee63da96035333235b305f5
Status: Downloaded newer image for storageos/plugin:latest
Error response from daemon: rpc error: code = 2 desc = oci runtime error: container_linux.go:247: starting container process caused "process_linux.go:359: container init caused \"rootfs_linux.go:54: mounting \\\"/var/lib/storageos\\\" to rootfs \\\"/var/lib/docker/plugins/aa6af64266a9bb5576d6d18bcd7fe2d193f643f03de2fb7be55ad3aa91865f07/rootfs\\\" at \\\"/var/lib/storageos\\\" caused \\\"stat /var/lib/storageos: no such file or directory\\\"\""
```

Cause: `/var/lib/storageos` must exist prior to plugin installation. Run
`mkdir /var/lib/storageos` prior to installing the plugin:

```bash
$ sudo mkdir /var/lib/storageos
$ sudo docker plugin install --alias storageos storageos/plugin
...
```

## Network Block Device (NBD)

The default on most linux distributions is to support 16 devices. Setting the
nbds_max parameter allows for more than 16.

By default 16 minor number devices are initialised per major node for handling
partitions. The number of partitions can be controlled by the max_part
parameter. Changing the default will break StorageOS, so either do not specify
the parameter, or if it is specified, the only valid values are 0 and 15.

If the wrong number of devices have been initialised it is possible to rmmod nbd
and then re-run modprobe. it is only possible to run rmmod if none of the
devices are in use.
