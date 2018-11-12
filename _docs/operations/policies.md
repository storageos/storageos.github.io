---
layout: guide
title: StorageOS Docs - Policies
anchor: operations
module: operations/policies
---

# Policies

Policies are a way to manage access to different StorageOS namespaces. 
Policies can be configured at the group or user level so access can be 
controlled granularly.

Users can belong to one or more groups to control their Namespace permissions.
Additionally user specific policies can be created to grant a user access to a
namespace. Users can belong to any number of groups and have access to any
number of individual namespaces configured.

>Note: Users are created with access to the default namespace. Policies cannot
be applied to the default namespace.

## Create a policy

To start creating policies, at least one custom namespace and user are required. To see
more information on how to create namespaces see our [Namespace guide]({%link
_docs/operations/namespaces.md %}), for users see our [Users CLI reference]({%link
_docs/reference/cli/user.md %}). 

```bash 
$ storageos namespace create testing --description quality-assurance
--display-name QA

$ storageos user create --user jim --groups qa

$ storageos policy create --user jim --namespace testing
```

The above commands created a namespace called testing, with a description and
display name. A user jim was then created in the qa group and finally jim was
given access rights to the testing namespace. 

## List all policies

To view policies, run:

```bash
$ storageos policy ls
ID                                    USER  GROUP  NAMESPACE
6ad3c709-a16f-aa61-27d3-ec53526046d5  jim          testing
```
## Inspect policies

To inspect policies, run:

```bash
$ storageos policy inspect 6ad3c709-a16f-aa61-27d3-ec53526046d5
[
    {
        "spec": {
            "user": "jim",
            "namespace": "testing"
        }
    }
]
```

## Removing policies

Removing a policy will remove access rights from users or groups that the
policy affected. 

To delete policies, run: 
```bash
$ storageos policy rm 6ad3c709-a16f-aa61-27d3-ec53526046d5 
```
