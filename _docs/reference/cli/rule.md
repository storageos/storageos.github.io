---
layout: guide
title: StorageOS Docs - Rules
anchor: reference
module: reference/cli/rule
---

# Rules

```bash
$ storageos rule

Usage:	storageos rule COMMAND

Manage rules

Options:
      --help   Print usage

Commands:
  create      Creates a rule. To create a rule that configures 2 replicas for volumes with the label env=prod, run:
storageos rule create --namespace default --selector env==prod --action add --label storageos.com/replicas=2 replicator

  inspect     Display detailed information on one or more rules
  ls          List rules
  rm          Remove one or more rules
  update      Update a rule

Run 'storageos rule COMMAND --help' for more information on a command.
```

### `storageos rule create`
To create a rule that configures 2 replicas for volumes with the label env=prod:

```bash
$ storageos rule create --namespace default --selector 'env==prod' --action add --label storageos.com/replicas=2 replicator
default/replicator
```

### `storageos rule inspect`
To inspect a rule:

```
$ storageos rule inspect default/replicator
[
    {
        "id": "9db3252a-bd14-885b-0d0a-b0da1dd2d4a1",
        "name": "replicator",
        "namespace": "default",
        "description": "",
        "active": true,
        "weight": 5,
        "action": "add",
        "selector": "env==prod",
        "labels": {
            "storageos.com/replicas": "2"
        }
    }
]
```

### `storageos rule ls`
To list all rules:

```bash
$ storageos rule ls
NAMESPACE/NAME        SELECTOR                       ACTION              LABELS
default/dev-marker    !storageos.com/replicas    add                 env=dev
default/prod-marker   storageos.com/replicas>1   add                 env=prod
default/replicator    env==prod                  add                 storageos.com/replicas=2
default/uat-marker    storageos.com/replicas<2   add                 env=uat
```

### `storageos rule rm`
To delete a rule:

```bash
$ storageos rule rm default/replicator
default/replicator
```
