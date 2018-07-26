---
layout: guide
title: StorageOS Docs - Deployment
anchor: install
module: install/deployment
---

# Deployment types

StorageOS may be deployed in compute only mode, which allows applications
running on nodes with no storage to consume storage from other nodes.

To deploy StorageOS on a node with no storage, specify the label
`storageos.com/deployment=computeonly`:

```bash
docker run -d --name storageos \
      -e HOSTNAME \
      -e JOIN=100.224.3.12 \
      -e LABELS='storageos.com/deployment=computeonly' \
      --net=host \
      --pid=host \
      --privileged \
      --cap-add SYS_ADMIN \
      --device /dev/fuse \
      -v /var/lib/storageos:/var/lib/storageos:rshared \
      -v /sys:/sys \
      -v /run/docker/plugins:/run/docker/plugins \
      storageos/node:1.0.0-rc4 server
```

The deployment types `computeonly` and `mixed` are supported, with `mixed` being
the default mode where storage and compute reside on the same node, also known
as hyperconverged.
