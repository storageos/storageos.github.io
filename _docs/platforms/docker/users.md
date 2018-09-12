---
layout: guide
title: StorageOS Docs - Users
anchor: platforms
module: platforms/docker/users
---

# Users and Policies

## Creating a new user

Users can be created, deleted and managed from the `storageos` [CLI]({% link _docs/reference/cli/index.md %}). For example to create a new non-admin user 'awesomeUser' and add them to the 'test' and 'dev' groups, run:

```bash
$ storageos user create --groups test,dev --role user awesomeUser
Password:
Confirm Password:
```

Usernames are case-sensitive and follow the format `[a-zA-Z0-9]+` (one or more alphanumeric characters).
Passwords are prompted for interactively to avoid passwords appearing in terminal logs, but can also be provided with the `--password` flag.
Passwords must not be < 8 characters long.

## List current users

```bash
$ storageos user ls
ID                                    USERNAME     GROUPS    ROLE
16965f92-7633-f1b4-700b-9b05b4a85ae5  awesomeUser  test,dev  user
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9  storageos              admin
```

## Remove users

Users can be deleted using the `storageos user rm` command. Multiple users can be selected at once, and both IDs or usernames can be used to select users.

```bash
$ storageos user ls
ID                                    USERNAME   GROUPS  ROLE
7add322d-806c-09a4-65ce-103e9c8c4701  removeMe1          user
0ff5f0d2-8fad-745c-f917-662f740019cc  removeMe2          user
234e09d2-12bd-b8b8-db54-efb73c53fdb8  removeMe3          user
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9  storageos          admin

$ storageos user rm removeMe1 removeMe2 234e09d2-12bd-b8b8-db54-efb73c53fdb8
removeMe1
removeMe2
234e09d2-12bd-b8b8-db54-efb73c53fdb8

$ storageos user ls
ID                                    USERNAME   GROUPS  ROLE
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9  storageos          admin
```

## Update a user

User information can also be updated from the CLI using the `storageos user update` command, using optional arguments to denote which field(s) need updating.
The following example updates a user's password, adds them to the group "testers" and removes them from the group "dev".

```bash
$ storageos user ls
ID                                    USERNAME     GROUPS  ROLE
e367ccf0-240d-538f-540f-5013784b5665  awesomeUser  dev     user
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9  storageos            admin

$ storageos user update --password --add-groups testers --remove-groups dev awesomeUser
Password:
Confirm Password:

$ storageos user ls
ID                                    USERNAME     GROUPS   ROLE
e367ccf0-240d-538f-540f-5013784b5665  awesomeUser  testers  user
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9  storageos             admin
```

>**Note**: In this case the `--password` flag is a boolean used to indicate that you wish to update the user's password.
The password will be prompted for interactively.

# Policies

## Adding policies

Policies can be added via the CLI using the `storageos policy create` command.
This command can be controlled either by using flags (`--user` etc.), or policy
files can be provided to the CLI.


### File format

The format for policy files is json line format (one object per line) and is similar to that of [Kubernetes' ABAC syntax](https://kubernetes.io/docs/admin/authorization/abac/).
These policy files detail acceptable actions within the system, if any of the policy entries match a request, then it is allowed.

```json
{"spec":{"user": "bob", "namespace": "legal"}}
{"spec":{"group": "compliance", "namespace": "legal"}}
```

The rules above will allow any user with the username bob, or in the group compliance, to access the legal namespace.

Access to a namespace grants the ability to create/update/remove volumes and rules within that namespace.


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
ID                                    USER  GROUP  NAMESPACE
99b04c50-32a7-4869-8e23-1e6b8b887228  foo          *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851  bar          testing
13de44a2-c50a-c225-9f65-871cfad0c838        baz    restricted
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
ID                                    USER  GROUP  NAMESPACE
24e90cfe-9dbe-482c-3b51-8d2a9c0e57fd  foo          *
34c868ef-4e4b-fb71-f0f7-fa94e4652776  bar          testing
8ced2820-7ad1-bd46-4d9f-d7dab1ba4c67        baz    restricted
```

>**Note**: It is also possible to consume this file format from stdin using the `--stdin` option.

## Listing current policies
Policies live in the system can be displayed using the `storageos policy ls` command.

```bash
$ storageos policy ls
ID                                    USER  GROUP  NAMESPACE
99b04c50-32a7-4869-8e23-1e6b8b887228  foo          *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851  bar          testing
13de44a2-c50a-c225-9f65-871cfad0c838        baz    restricted
```

## Removing policies
Policies can be removed from the system using the `storageos policy rm` command. Multiple policies can be selected at once.

```bash
$ storageos policy ls
ID                                    USER  GROUP  NAMESPACE
99b04c50-32a7-4869-8e23-1e6b8b887228  foo          *
c14aa3ff-99f7-d0fb-41e9-ad45b0919851  bar          testing
13de44a2-c50a-c225-9f65-871cfad0c838        baz    restricted

$ storageos policy rm 99b04c50-32a7-4869-8e23-1e6b8b887228 13de44a2-c50a-c225-9f65-871cfad0c838

$ storageos policy ls
ID                                    USER  GROUP  NAMESPACE
c14aa3ff-99f7-d0fb-41e9-ad45b0919851  bar          testing
```

>**Note**: Once `storageos policy rm` has completed, the selected policies will have all been removed from the system.
However, during this call requests may still be checked against some subset of the policies to be removed.
