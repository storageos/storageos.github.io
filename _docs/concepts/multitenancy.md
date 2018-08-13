---
layout: guide
title: StorageOS Docs - Multitenancy
anchor: concepts
module: concepts/multitenancy
---

# Multitenancy

Multiple users, teams or projects can share a StorageOS cluster. 





StorageOS provides mechanisms for managing how different projects or teams share a StorageOS cluster. Volumes and rules are namespaced.


Namespaces help different projects or teams share a StorageOS cluster. No namespaces are created by default, and users can have any number of namespaces.

Namespaces apply to volumes and rules.


# Quality of service

You can deprioritize the traffic on noisy apps by throttling ie. reducing the rate of disk I/O.


# Users

User accounts facilitate granular permissioning of acceptable actions within the
system by the use of policies
On initial startup there is only the admin `storageos` user.

## Admin vs User accounts

Admin users are treated as super-users which can perform any action within the
system, regardless of policies set. Admins also have the added ability to add,
update and remove users, their policies and perform other administrative roles
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
