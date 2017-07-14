---
layout: guide
title: StorageOS Docs - Namespaces
anchor: reference
module: reference/cli/namespace
---

# Namespaces

```bash
Usage:	storageos namespace COMMAND

Manage namespaces

Options:
      --help   Print usage

Commands:
  create      Create a namespace
  inspect     Display detailed information on one or more namespaces
  ls          List namespaces
  rm          Remove one or more namespaces
  update      Update a namespace

Run 'storageos namespace COMMAND --help' for more information on a command.
```

### `storageos namespace create`
To create a namespace:

```bash
$ storageos namespace create legal --description compliance-volumes
legal
```

Add the `--display-name` flag to set a display-friendly name.

### `storageos namespace inspect`

Check if a namespace has labels applied.

```bash
$ storageos namespace inspect legal | grep labels
        "labels": null,
```

### `storageos namespace ls`

To view namespaces:

```bash
$ storageos namespace ls -q
default
legal
performance
```

Remove `-q` for full details

### `storageos namespace rm`
To remove a namespace (add --force to remove namespaces with mounted volumes):
```bash
$ storageos namespace rm legal
legal
```
