---
layout: guide
title: StorageOS Docs - Licence
anchor: reference
module: reference/cli/licence
---

# Licence

```bash
$ storageos licence

Usage:  storageos licence COMMAND

Manage the licence

Options:
      --help   Print usage

Commands:
  apply       Apply a new licence, Either provide the filename of the licence file or write to stdin.
        E.g. "storageos licence apply --filename=licence"
        E.g. "cat licence | storageos licence apply --stdin"
  inspect     Display detailed information on the licence
  rm          Remove the current licence

Run 'storageos licence COMMAND --help' for more information on a command.
```

### `storageos licence apply`

To apply a new licence from a licence file to override the existing one, run:

```bash
$ storageos licence apply --filename=licence
```

To apply a new licence from clipboard to override the existing one, run:

```bash
$ echo PASTE-THE-LICENCE-KEY-HERE | storageos licence apply --stdin
```

### `storageos licence inspect`

To display detailed information on the current licence, run:

```bash
$ storageos licence inspect
[
    {
        "clusterID": "ea0f97a1-9fa5-4977-9919-e9fb4bbd8708",
        "storage": 100,
        "validUntil": "9999-01-01T00:00:00Z",
        "licenceType": "basic",
        "features": {
            "HA": true
        },
        "unregistered": true
    }
]
```

### `storageos licence rm`

To delete the previously applied licence from the system, run:

```bash
$ storageos licence rm
```
