---
layout: guide
title: StorageOS Docs - Troubleshooting installation
anchor: install
module: install/troubleshooting
---

## Common issues

```
Error response from daemon: dial unix /run/docker/plugins/a-very-long-hash-value/storageos.sock: connect: connection refused
```

This error indicates that the StorageOS plugin container did not successfully
start during installation. This is usualy due to incorrect option values
being passed to the docker plugin installation command.

Please refer to the [plugin]({%link _docs/install/docker/plugin.md %})
or [container]({%link _docs/install/docker/container.md %}) install instructions
instructions, or run `journalctl -u docker` for more debug output
(`docker logs storageos` if performing the container install).

Common causes of this issue are:

- Missing or invalid `JOIN` information
- Inability to contact the StorageOS [discovery service](http://docs.storageos.com/docs/install/prerequisites/clusterdiscovery)
  (when using a cluster token)
- Missing `-v /run/docker/plugins:/run/docker/plugins` (In the case of the container install only)


## Gotchas

- Changing that value of `JOIN` in dev environments:

  When trying out StorageOS in Dev/POC environments it is common to change the value of the `JOIN` variable between installs.
  However, if a cluster has previously been made, this information (the old `JOIN` value) is cached and used in preference.
  When re-installing StorageOS, it is necessary to first clear the old data in `/var/lib/storageos`
  ```
  $ rm -rf /var/lib/storageos*
  ```
  >**NOTE**: This command will also remove any data stored on this node

- Re-using an old cluster token:

  When re-installing StorageOS it is possible to make the mistake of using an old cluster token from a previous install.
  This will cause the new StorageOS install to attempt to join the old cluster, normally resulting in a failure.

  ```
  $ docker plugin install --alias storageos storageos/plugin:0.9.0 JOIN=$PREVIOUS_CLUSTER_ID
  0.9.0: Pulling from storageos/plugin
  a4eba3fe5636: Download complete 
  Digest: sha256:4f4a87e1506b7357815f574ded1ef7fd53e94683ce9d802a134019dfd8e9580a
  Status: Downloaded newer image for storageos/plugin:0.9.0
  Installed plugin storageos/plugin:0.9.0

  $ storageos cluster health
  API not responding to list nodes: API error (Service Unavailable): KV Store Unavailable
  ```
