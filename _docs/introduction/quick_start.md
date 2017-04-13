---
layout: guide
title: StorageOS Docs - Quick start
anchor: introduction
module: introduction/quick_start
# Last reviewed by cheryl.hung@storageos.com on 2017-04-10
---

# Quick start

The fastest way to try out StorageOS is to download the plugin from the Docker
Hub.

```bash
$ sudo docker plugin install --grant-all-permissions --alias storageos storageos/plugin KV_BACKEND=boltdb
0.7.2: Pulling from storageos/plugin
ff866c314f8c: Download complete
Digest: sha256:759bcc3dfa7b76bf555307a332ff7db9358e63eae681487bde81bf3860af9067
Status: Downloaded newer image for storageos/plugin:0.7.2
Installed plugin storageos/plugin:0.7.2
```

If you don't have Docker 1.13+ installed, check out the
[node install](../install/nodeinstall.html) and [cluster install](../install/clusterinstall.html) docs.
