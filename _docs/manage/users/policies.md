---
layout: guide
title: StorageOS Docs - Policies
anchor: manage
module: manage/users/policies
---

# Policies

Policies are a simple Attribute-Based Access Control records that are used to permission users (or groups) to namespaces.

>**Note**: On initial startup there is only the `storageos` user and no policies are in place. If no policies exist, all users can access all namespaces.

>**Note**: Admin users (users with their role field set to `admin`) are treated as super-users which can perform any action within the system, regardless of policies set.


## Adding policies

Policies can be added via the CLI application using the `storageos policy create` command. This command can be controlled either by using flags (`--user` etc.),
or policy files can be provided to the CLI.


### File format

The format for policy files is json line format (one object per line) and is similar to that of [Kubernetes' ABAC syntax](https://kubernetes.io/docs/admin/authorization/abac/).
These policy files detail acceptable actions within the system, if any of the policy entries match a request, then it is allowed.

```json
{"spec":{"user": "bob", "namespace": "legal"}}
{"spec":{"group": "compliance", "namespace": "legal"}}
```

The rules above will allow any user with the username bob, or in the group compliance, to access the legal namespace.

Access to a [namespace]({% link _docs/manage/volumes/namespaces.md%}) grants the ability to create/update/remove
[volumes]({% link _docs/manage/volumes/index.md%}) and [rules]({% link _docs/operations/rules.md%}) within that namespace.


### Adding using flags
Policies can be added using flags. These flags share the same name as their matching keys in the `spec` field of a policy object.

The following commands add policies (using the flags interface) to:
- Grant the user "foo" access to all namespaces
- Grant the user "bar" access to the "testing" namespace
- Grant all users in the group "baz" access to the "restricted" namespace

```bash
$ storageos policy create --user foo --namespace "*"
$ storageos policy create --user bar --namespace testing
$ storageos policy create --group baz --namespace restricted

$ storageos policy ls
ID                                     USER                GROUP               NAMESPACE
99b04c50-32a7-4869-8e23-1e6b8b887228   foo                                     *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851   bar                                     testing
13de44a2-c50a-c225-9f65-871cfad0c838                       baz                 restricted
```

### Adding using jsonl files
Policies can also be added using Kubernetes style policy files (json line format). In this example we use these two files:

p1.jsonl:
```json
{"spec":{"user":"foo", "namespace": "*"}}
{"spec":{"user":"bar", "namespace": "testing"}}
```

p2.jsonl:
```json
{"spec":{"group":"baz", "namespace": "restricted"}}
```

These files are provided using the optional argument `--policies`
```bash
$ storageos policy create --policies='p1.jsonl,p2.jsonl'

$ storageos policy ls
ID                                     USER                GROUP               NAMESPACE
24e90cfe-9dbe-482c-3b51-8d2a9c0e57fd   foo                                     *
34c868ef-4e4b-fb71-f0f7-fa94e4652776   bar                                     testing
8ced2820-7ad1-bd46-4d9f-d7dab1ba4c67                       baz                 restricted
```

>**Note**: It is also possible to consume this file format from stdin using the `--stdin` option.

## Listing current policies
Policies live in the system can be displayed using the `storageos policy ls` command.

```bash
$ storageos policy ls
ID                                     USER                GROUP               NAMESPACE
99b04c50-32a7-4869-8e23-1e6b8b887228   foo                                     *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851   bar                                     testing
13de44a2-c50a-c225-9f65-871cfad0c838                       baz                 restricted
```

## Removing policies
Policies can be removed from the system using the `storageos policy rm` command. Multiple policies can be selected at once.

```bash
$ storageos policy ls
ID                                     USER                GROUP               NAMESPACE
99b04c50-32a7-4869-8e23-1e6b8b887228   foo                                     *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851   bar                                     testing
13de44a2-c50a-c225-9f65-871cfad0c838                       baz                 restricted

$ storageos policy rm 99b04c50-32a7-4869-8e23-1e6b8b887228 13de44a2-c50a-c225-9f65-871cfad0c838

$ storageos policy ls
ID                                     USER                GROUP               NAMESPACE
c14aa3ff-99f7-d0fb-41e9-ad45b0919851   bar                                     testing
```

>**Note**: Once `storageos policy rm` has completed, the selected policies will have all been removed from the system.
However, during this call requests may still be checked against some subset of the policies to be removed.
