---
layout: guide
title: StorageOS Docs - Multitenancy
anchor: concepts
module: concepts/multitenancy
---

# Multitenancy

StorageOS provides mechanisms for managing how different projects or teams share
a StorageOS cluster.

Volumes and rules are namespaced, and namespaces in Kubernetes propagate
automatically to StorageOS namespaces.

You can deprioritize the traffic on noisy applications by setting
`storageos.com/throttle=true` on a volume. This reduces the rate of disk I/O and
enables other applications to take priority.

# Users, groups and policies

User accounts facilitate granular permissioning of acceptable actions within the
system by the use of policies. On initial startup there is only the admin
`storageos` user.

Users can be members of multiple groups.

## Admin vs User accounts

Admin users are treated as super-users which can perform any action within the
system, regardless of policies set. Admins also have the added ability to add,
update and remove users, their policies and to perform other administrative roles
within the system, such as managing or creating new namespaces.

Users only have the ability to change their password and have access to the
namespaces granted to them by the policies set. Access to a namespace grants a
user the ability to create/update/remove volumes and rules within that
namespace.

# Policies

Policies are a simple Attribute-Based Access Control records that are used to
permission users (or groups) to namespaces.

>**Note**: On initial startup there is only the `storageos` user and no policies
>are in place. If no policies exist, all users can access all namespaces.

>**Note**: Admin users (users with their role field set to `admin`) are treated
>as super-users which can perform any action within the system, regardless of
>policies set.
