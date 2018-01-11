---
layout: guide
title: StorageOS Docs - API
anchor: reference
module: reference/cli/cluster
---

# Cluster

```bash
$ storageos cluster

Usage:	storageos cluster COMMAND

Manage clusters

Options:
      --help   Print usage

Commands:
  create      Creates a cluster initialization token.
  inspect     Display detailed information on one or more cluster
  rm          Remove one or more clusters

Run 'storageos cluster COMMAND --help' for more information on a command.
```

### `storageos cluster create`

To create a cluster token for [cluster discovery]({%link
_docs/install/prerequisites/clusterdiscovery.md %}):
```bash
$ storageos cluster create
207f0026-3844-40e0-884b-729d79c124b8
```

The embedded key-value cluster size determines the [node failure
tolerance]({%link _docs/install/prerequisites/clusterdiscovery.md %}) and can be
adjusted with the `--size` flag. This does not affect how many StorageOS nodes
can join the cluster.

### `storageos cluster inspect`

To inspect a cluster:
```bash
$ storageos cluster inspect 207f0026-3844-40e0-884b-729d79c124b8
[
    {
        "id": "207f0026-3844-40e0-884b-729d79c124b8",
        "size": 3,
        "createdAt": "2017-07-14T13:17:29.226058526Z",
        "updatedAt": "2017-07-14T13:17:29.22605861Z"
    }
]
```

### `storageos cluster health`

To view the status of various components:

```bash
$ storageos cluster health
NODE                ADDRESS             STATUS              KV                  NATS                SCHEDULER          DFS_CLIENT          DFS_SERVER          DIRECTOR            FS_DRIVER           FS
storageos-3         192.168.50.102      Healthy             alive               alive               alive              alive               alive               alive               alive               alive
storageos-2         192.168.50.101      Healthy             alive               alive               alive              alive               alive               alive               alive               alive
storageos-1         192.168.50.100      Healthy             alive               alive               alive              alive               alive               alive               alive               alive
```

### `storageos cluster rm`

To remove a cluster:
```bash
storageos cluster rm 207f0026-3844-40e0-884b-729d79c124b8
207f0026-3844-40e0-884b-729d79c124b8
```
