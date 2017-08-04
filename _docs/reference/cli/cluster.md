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

To create a cluster:
```bash
$ storageos cluster create
cluster token: 207f0026-3844-40e0-884b-729d79c124b8
```

The default cluster size is 3; pass `-s` to set the size to 3-7.

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
