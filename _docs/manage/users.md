---
layout: guide
title: StorageOS Docs - Users
anchor: manage
module: manage/users
---

# Users

User accounts facilitate granular permissioning of acceptable actions within the system by the use of policies.

>**Note**: On initial startup there is only the storageos user which is an admin user.

## Admin vs User accounts

Admin users are treated as super-users which can perform any action within the system, regardless of policies set.
Admins also have the added ability to add, update and remove users policies and perform other administrative roles within the system.

Users only have the ability to change their password and have access to the namespaces granted to them by the policies set.

## CLI
### Creating a new user

Users can be created, deleted and managed from the storageos CLI. For example to create a new non-admin user 'awesomeUser' and add them to the 'test' and 'dev' groups, Run:

```bash
$ storageos user create bob --groups test,dev --password --role user awesomeUser
Password: 
Confirm Password: 
```

>**Note**: Passwords are prompted for interactively to avoid passwords appearing in terminal logs

### Listing current users

```bash
$ storageos user ls
ID                                     USERNAME            GROUPS              ROLE
16965f92-7633-f1b4-700b-9b05b4a85ae5   awesomeUser         test,dev            user
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9   storageos                               admin
```

### Removing users

Users can be deleted using the `storageos user rm` command. Multiple users can be selected at once, and both IDs or Usernames can be used to select users.

```bash
$ storageos user ls
ID                                     USERNAME            GROUPS              ROLE
7add322d-806c-09a4-65ce-103e9c8c4701   removeMe1                               user
0ff5f0d2-8fad-745c-f917-662f740019cc   removeMe2                               user
234e09d2-12bd-b8b8-db54-efb73c53fdb8   removeMe3                               user
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9   storageos                               admin

$ storageos user rm removeMe1 removeMe2 234e09d2-12bd-b8b8-db54-efb73c53fdb8
removeMe1
removeMe2
234e09d2-12bd-b8b8-db54-efb73c53fdb8

$ storageos user ls
ID                                     USERNAME            GROUPS              ROLE
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9   storageos                               admin
```

### Updating a user

User information can also be updated from the CLI using the `storageos user update` command, using optional arguments to denote which field(s) need updating.
The following example updates a user's password, adds them to the group "testers" and removes them from the group "dev".

```bash
$ storageos user ls
ID                                     USERNAME            GROUPS              ROLE
e367ccf0-240d-538f-540f-5013784b5665   awesomeUser         dev                 user
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9   storageos                               admin

$ storageos user update --password --add-groups testers --remove-groups dev awesomeUser
Password: 
Confirm Password: 

$ storageos user ls
ID                                     USERNAME            GROUPS              ROLE
e367ccf0-240d-538f-540f-5013784b5665   awesomeUser         testers             user
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9   storageos                               admin
```
