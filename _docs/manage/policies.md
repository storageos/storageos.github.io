---
layout: guide
title: StorageOS Docs - Policies
anchor: manage
module: manage/policies
---

# Policies

Policies are a simple Attribute-Based Access Control records that are used to permission users (or groups) to namespaces.

>**Note**: On initial startup there is only the storageos user and no policies are in place. If no policies exist, all users can access all namespaces.

## Format

The format for policy rules is similar to that of Kubernetes' ABAC syntax, defining acceptable actions within the system. If any of the policy entries match the
action is allowed.

>**Note**: Admin users are treated as super-users which can perform any action within the system, regardless of policies set.

```json
{"spec":{"user": "bob", "namespace": "legal"}}
{"spec":{"group": "compliance", "namespace": "legal"}}
```

The rules above will allow any user with the username bob, or in the group compliance, to access the legal namespace.

## CLI

### Adding policies
Policies can be added via the CLI application using the `storageos policy create command. New policies can be supplied to this command with n-many positional arguments, a set of files or by reading from stdin. The positional arguments are expected to be in the form of either a single policy object or a json list of policy objects. The file input is expected to be in json line format (one object per line, the same as kubernetes). Reading from stdin will accept either json line format, or json objects/lists.

#### Adding using positional args
Policies can be added using positional arguments. They are expected to either be policy objects, or a json list of policy objects. In this example both are used.

```bash
$ storageos policy create '{"spec":{"user":"foo", "namespace": "*"}}' '[{"spec":{"user":"bar", "namespace": "testing"}}, {"spec":{"group":"baz", "namespace": "restricted"}}]'

$ storageos policy ls
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
99b04c50-32a7-4869-8e23-1e6b8b887228   foo                                     false                                                       *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851   bar                                     false                                                       testing
13de44a2-c50a-c225-9f65-871cfad0c838                       baz                 false                                                       restricted
```

#### Adding using jsonl files
Policies can also be added using kubernetes style policy files (json line format). In this example we use these two files:

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
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
24e90cfe-9dbe-482c-3b51-8d2a9c0e57fd   foo                                     false                                                       *
34c868ef-4e4b-fb71-f0f7-fa94e4652776   bar                                     false                                                       testing
8ced2820-7ad1-bd46-4d9f-d7dab1ba4c67                       baz                 false                                                       restricted
```
#### Adding using stdin
The final method of adding policies is using the stdin for the `storageos policy create` command, using the `--stdin` option. The stdin accepts input in both json form and jsonl form.

json form:
```bash
$ echo '{"spec":{"user":"foo", "namespace": "*"}}' | storageos policy create --stdin

$ storageos policy ls
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
1dcd73d1-23de-0329-7501-fc7aa60affb2   foo                                     false                                                       *
```

jsonl form:
```bash
$ cat p1.jsonl | storageos policy create --stdin

$ storageos policy ls
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
976a74bd-630c-eeb5-8c33-b033b99dcf68   foo                                     false                                                       *
f1e33492-aa9b-3922-7824-383941d37a5d   bar                                     false                                                       testing
```

### Listing current policies
Policies live in the system can be displayed using the `storageos policy ls` command.

```bash
$ storageos policy ls
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
99b04c50-32a7-4869-8e23-1e6b8b887228   foo                                     false                                                       *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851   bar                                     false                                                       testing
13de44a2-c50a-c225-9f65-871cfad0c838                       baz                 false                                                       restricted
```

### Removing policies
Policies can be removed from the system using the `storageos policy rm` command. Multiple policies can be selected at once.

```bash
$ storageos policy ls
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
99b04c50-32a7-4869-8e23-1e6b8b887228   foo                                     false                                                       *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851   bar                                     false                                                       testing
13de44a2-c50a-c225-9f65-871cfad0c838                       baz                 false                                                       restricted

$ storageos policy rm 99b04c50-32a7-4869-8e23-1e6b8b887228 13de44a2-c50a-c225-9f65-871cfad0c838

$ storageos policy ls
ID                                     USER                GROUP               READONLY            APIGROUP            RESOURCE            NAMESPACE           NONRESOURCEPATH
c14aa3ff-99f7-d0fb-41e9-ad45b0919851   bar                                     false                                                       testing
```
