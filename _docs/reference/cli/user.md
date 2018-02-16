---
layout: guide
title: StorageOS Docs - Users
anchor: reference
module: reference/cli/user
---

# Users

(Download and install the StorageOS CLI [here]({%link _docs/reference/cli/index.md %})

```bash
$ storageos user

Usage:	storageos user COMMAND

Manage users

Options:
      --help   Print usage

Commands:
  create      Create a new User, E.g. "storageos user create --password alice" (interactive password prompt)
  inspect     Display detailed information on one or more user(s)
  ls          List users
  rm          Remove one or more user(s)
  update      Update select fields in a user account

Run 'storageos user COMMAND --help' for more information on a command.
```

### `storageos user create`
To create a new (admin) user "awesomeUser" with a interactively provided password that is a member of the group "dev":

```bash
$ storageos user create --role admin --groups dev awesomeUser
Password: 
Confirm Password: 
```

For multiple groups, use comma separation. E.g. `--groups dev,testing,deploy`
For non admin users use `--role user`

### `storageos user inspect`
To display detailed information on the user "awesomeUser", run:

```bash
$ storageos user inspect awesomeUser
[
    {
        "id": "861511a8-2843-1031-724c-2cabaa2ca4e9",
        "username": "awesomeUser",
        "groups": "dev",
        "role": "admin"
    }
]
```
>**Note**: Either the username or the ID can be used to select the user.

### `storageos user ls`
To list the users on the system, run:

```bash
$ storageos user ls
ID                                     USERNAME            GROUPS                 ROLE
861511a8-2843-1031-724c-2cabaa2ca4e9   awesomeUser         dev                    admin
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9   storageos                                  admin
```

### `storageos user rm`
To delete a user from the system, run:

```bash
$ storageos user rm 861511a8-2843-1031-724c-2cabaa2ca4e9
861511a8-2843-1031-724c-2cabaa2ca4e9
```

The user is now deleted.
```bash
$ storageos user ls
ID                                     USERNAME            GROUPS                 ROLE
9d6f2ea9-3c7d-2358-7d81-b29c50e10cc9   storageos                                  admin
```
>**Note**: Either the username or the ID can be used to select the user.

### `storageos user update`
Change the password of the user "awesomeUser":

```bash
$ storageos user update --password awesomeUser
Password: 
Confirm Password: 
```

Change the username of the user "awesomeUser":

```bash
$ storageos user update --username moreAwesomeUser awesomeUser
```

Add "awesomeUser" to the dev group:

```bash
$ storageos user update --add-groups dev awesomeUser
```

Remove "awesomeUser" from the dev group:

```bash
$ storageos user update --remove-groups dev awesomeUser
```

Revoke "awesomeUser"'s admin privileges:

```bash
$ storageos user update --role user awesomeUser
```

Restore "awesomeUser"'s admin privileges:

```bash
$ storageos user update --role admin awesomeUser
```
