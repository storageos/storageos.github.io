---
layout: guide
title: StorageOS Docs - Docker volume plugin
anchor: install
module: install/docker/plugin
---

# Docker Managed Plugin

Install the StorageOS volume plugin on Docker Engine 1.13+.


## Prerequisites

Ensure you have a functioning [key-value store and NBD is enabled]({%link _docs/install/docker/index.md %}).

## Install the volume plugin

In order to make plugin upgrades easier, install the plugin using
`--alias storageos`.  This ensures that volumes provisioned with a previous
version of the plugin continue to function after the upgrade.  (By default,
Docker ties volumes to the plugin version.)

```bash
$ docker plugin install --alias storageos storageos/plugin
Plugin "storageos/plugin" is requesting the following privileges:
 - network: [host]
 - mount: [/var/lib/storageos]
 - mount: [/dev]
 - device: [/dev/fuse]
 - allow-all-devices: [true]
 - capabilities: [CAP_SYS_ADMIN]
Do you grant the above permissions? [y/N]
```

If the KV store is not local, supply the IP address of the Consul service using
the `KV_ADDR` environment variable.


Volumes should then be provisioned using the alias i.e. `--volume-driver storageos`.
