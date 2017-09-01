---
layout: guide
title: StorageOS Docs - Release notes
anchor: reference
module: reference/release_notes
---

# Beta warning

StorageOS is currently in Beta. This allows users to explore our software prior
to General Availability (GA) release. Any feedback on software problems and
usability will help improve our product and allows us to track issues and fix
them.

As public Beta software, StorageOS has yet to be released commercially and may
contain imperfections causing the software not to perform as well as GA release
software. **Therefore we recommend you only install this on non-production,
non-business critical infrastructure or devices.**

Before the GA release, data formats used by StorageOS may change and there may
not be an automated migration process. When upgrades break compatibility or
require manual migration processes we will endeavour to make this clear in the
release notes.

We recommend always using "tagged" versions of StorageOS rather than "latest",
and to perform upgrades only after reading the release notes.

## Known Issues

- Once a 0.8.0 cluster has been established, it is currently not possible to add
  or remove members.  We expect this functionality to come in 0.8.1, and welcome
  feedback on how this should behave.
- `storageos volume mount <vol> <mountpoint>` sometimes hangs on Managed Plugin
  installs.  Volumes mount into containers correctly using Docker.
- Docker can only access volumes created in the `default` namespace.
- Clients mounting volumes from RHEL7/CentOS 7 will experience degraded
  performance due to the absence of the [nbd kernel module]({%link _docs/install/prerequisites/nbd.md %}) on those platforms.

## Upgrades

Due to the nature the KV Store change there is no upgrade method from 0.7.x to
0.8.0+.  Our recommendation is to create a new cluster, paying attention to the
new parameters (`CLUSTER_ID` and `INITIAL_CLUSTER`)

Upgrades within a minor release (e.g. 0.7.9 -> 0.7.10) can be done by restarting
the StorageOS container with the new version.

We will endeavor to make upgrades more seamless in the future.

## 0.8.1

Improved

- NBD device numbers now start at 1 instead of 0 to defend against default values

## 0.8.0

This is our first feature release since launching our public beta, and it
focusses on feedback from users.  As always, please let us know how you are using
StorageOS, what problems it is solving for you and how it can improve.  Join our
[Slack channel!](http://slack.storageos.com)

New

- Embedded KV Store based on etcd to further simplify deployment and ongoing
  cluster management.  Support for external Consul KV clusters has been
  deprecated, though external etcd clusters are now supported.
- Cluster discovery service to help bootstrap clusters.  Allocate a new cluster
  with `storageos cluster create` and pass the cluster identifier to each
  StorageOS node in the `CLUSTER_ID` environment variable to allow nodes to
  discover the cluster without specifying hostnames or ip addresses.
- Access control policies can restrict access to volumes and rules created
  within a namespace.
- User and group management allows multiple users to be created and then used to
  apply access policy by group membership or named account.
- Anonymized usage metrics are collected and sent to StorageOS to help us better
  understand usage patterns so we can focus our efforts accordingly.  Metrics
  can be disabled by setting the `DISABLE_TELEMETRY` environment variable to 
  `true`.
- Location-based scheduling allows administrators to specify scheduling
  constraints on volumes at creation time.  This provides a simple mechanism to
  influence data placement.  (e.g. The volume's data may only be stored on nodes
  which have their environment label set to `production`)
- Cluster health reporting with CLI (`storageos cluster health`)

Improved

- Graceful behaviour when communication blocked by firewalls
- Docker integration now supports ext2/3/4, btrfs and xfs
- Environment variable validation
- Selectors for rules
- Use default namespace when not specified
- Internal volume performance counters
- API can report health while waiting for cluster to initialize

Fixed

- Better behaviour when communication blocked by firewalls
- Ensure namespaces are unique when creating
- Volume create should give error when size=0
- CLI/API filters not working as expected
- Can't edit a pool with the CLI
- Excessive logging on network timeouts

## 0.7.10

This release continues our focus on stability and better test coverage across a
growing suite of platforms and usage scenarios.

New

- Keepalives for replication though firewalls

Improved

- Graceful shutdown internal cleanup
- User authentication internals made extensible to other auth providers
- Internal changes to allow different log levels per module

Fixed

- Removed log entries where events are raised and logged again
- Consolidated log messages when KV store is not available

## 0.7.9

New

- Maintenance mode to allow partial startup when the KV store is not ready

Improved

- Better write parallelization performance

Fixed

- Issue with volume deletion

## 0.7.8

New

- Node statistics reporting
- Compression (in-transit and at-rest) enabled by default

Improved

- Refactored startup process
- Better volume distribution across cluster
- Relaxed volume naming requirements to support Docker dynamic volumes
- More instrumentation counters for volume stats
- Improved data plane error handling and retry logic
- Replication enhancements
- Ongoing log-level tuning to reduce noise

Fixed

- Issue removing metadata on volume destroy
- Improved compression performance
- Default volume size now consistent across CLI/API/Docker/Kubernetes
- KV Store documentation (thanks @wcgcoder)

## 0.7.7

- Fix issue with replication after node failure

## 0.7.6

- Log formatting improvements
- Do not mark a recovered controller available immediately, wait to detect
  flapping
- Mount lock improvements
- Docker should use ext4 as default filesystem

## 0.7.5

- Remove bash

## 0.7.4

- Log formatting improvements
- Add support for ext2, ext3, xfs and btrfs filesystem types
- Don't allow pool delete with active volumes

## 0.7.3 and earlier

- Unreleased private betas
