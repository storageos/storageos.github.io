---
layout: guide
title: StorageOS Docs - Policies
anchor: reference
module: reference/cli/policy
---

# Policies
```bash
$ storageos policy

Usage:	storageos policy COMMAND

Manage policies

Options:
      --help   Print usage

Commands:
  create      Create a new policy, Either provide the set of policy files, provide json input or write to stdin.
		E.g. "storageos policy create --policies='rules1.jsonl,rules2.jsonl'"
  inspect     Display detailed information on one or more polic(y|ies)
  ls          List policies
  rm          Remove one or more polic(y|ies)

Run 'storageos policy COMMAND --help' for more information on a command.
```

### `storageos policy create`
To create a new policy that allows users in the group "developers" to access the namespace "staging", run:

```bash
$ storageos policy create '{"spec":{"group": "developers", "namespace": "staging"}}'
```

### `storageos policy inspect`
To display detailed information on one or more policies, run:

```bash
$ storageos policy inspect 9fb096af-0a16-d1d2-5416-b637f0194b3f
[
    {
        "spec": {
            "group": "developers",
            "namespace": "staging"
        }
    }
]
```
>**Note**: The ID used is the policy ID as displayed in `storageos policy ls`

### `storageos policy ls`
To list the policies on the system, run:

```bash
$ storageos policy ls
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
9fb096af-0a16-d1d2-5416-b637f0194b3f                       developers          false                                                       staging
f1e33492-aa9b-3922-7824-383941d37a5d                       testers             false                                                       staging
```

### `storageos policy rm`
To delete a policy from the system, run:

```bash
$ storageos user rm 9fb096af-0a16-d1d2-5416-b637f0194b3f
9fb096af-0a16-d1d2-5416-b637f0194b3f
```

The policy is now deleted.

```bash
$ storageos policy ls
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
f1e33492-aa9b-3922-7824-383941d37a5d                       testers             false                                                       staging
```

>**Note**: The ID used is the policy ID as displayed in `storageos policy ls`
