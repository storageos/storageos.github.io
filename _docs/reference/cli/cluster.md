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

Aliases:
  cluster, c

Options:
      --help   Print usage

Commands:
  create      Creates a cluster initialization token.
  health      Displays the cluster's health.  When a cluster id is provided, uses the discovery service to discover nodes.
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

### `storageos cluster health`

To view the status of cluster nodes:

```bash
$ storageos cluster Healthy
NODE         ADDRESS         CP_STATUS  DP_STATUS
storageos-1  192.168.50.100  Healthy    Healthy
storageos-2  192.168.50.101  Healthy    Healthy
storageos-3  192.168.50.102  Healthy    Healthy
```

To view the status in more detail there are additional format 
options which can be given to the `--format` flag:

- `cp` shows the status of control plane components
- `dp` shows the status of data plane components
- `detailed` shows the status of control plane and data plane components

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

### `storageos cluster rm`

To remove a cluster:
```bash
storageos cluster rm 207f0026-3844-40e0-884b-729d79c124b8
207f0026-3844-40e0-884b-729d79c124b8
```
