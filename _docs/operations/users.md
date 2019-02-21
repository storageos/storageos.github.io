---
layout: guide
title: StorageOS Docs - User Management
anchor: operations
module: operations/users
---

# Managing Users


A StorageOS cluster admin can create users and restrict their access rights to
StorageOS [namespaces]({%link _docs/operations/namespaces.md %}) using
[policies]({%link _docs/operations/policies.md %}).

>Note: Users are created with access to the default namespace. This access is
>only revoked when a policy is created for the user or their group. 

## Creating users

To create a user with the CLI, run:

```bash
$ storageos user create jim --groups qa
```
The above command will create a user named jim and add them to the group qa.
The command will also prompt you to enter a password for the newly created
user. 

The groups flag is optional and the group will be created if it does not
already exist. 

## List all users
To view all users, run:

```bash
$ storageos user ls
ID                                    USERNAME   GROUPS  ROLE
a3b2948c-c5ef-116c-35c0-0cf4a42acf79  storageos          admin
395f9e99-8f60-52e7-6a90-36096666fea3  test       test    user
```

## Inspect users
To inspect a user, run:
```bash
$ storageos user inspect jim
[
    {
        "id": "7f27fa40-ffdf-c443-1e60-214378003b97",
        "username": "jim",
        "groups": "qa",
        "role": "user"
    }
]
```

## Update a user
To update a users attributes, run:

```bash
$ storageos user update jim --add-groups dev
```
The above command would add jim to the dev group. To see all the options that
update has use the command below:

```bash
$ storageos user update --help
```

## Deleting users
To delete a user, run:

```bash
$ storageos user rm jim
```
## Altering the StorageOS API account

When installing with the StorageOS Operator, the StorageOS API account is
defined by the [storageos-api
secret](/docs/platforms/kubernetes/install/1.13#create-a-secret).

For installations using the native driver, Kubernetes uses the account defined
in the secret to authenticate against the StorageOS API. Therefore if the
account details are changed, the Kubernetes storageos-api secret needs to be
updated. In order to update the secret you need to base64 encode the new
username/password and edit the storageos-api secret to reflect the new account
details.

For installations using CSI the storageos-api secret is used to define the
default account credentials. However as Kubernetes communicates with StorageOS
via the CSI socket, the secret is not used after cluster bootstrapping.

```bash
echo -n USERNAME | base64
kubectl edit secret storageos-api
```
