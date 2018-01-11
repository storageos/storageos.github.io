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

## Upgrades

Upgrades can be performed by restarting the StorageOS node container with the
new version, or by performing `docker plugin upgrade` on Docker Managed Plugin
installs.

Before a node is upgraded, applications local to the node that mount StorageOS
volumes should be migrated to other cluster nodes or their data volumes will be
unavailable while the StorageOS container restarts.

Where there are special considerations they are described below.

### 0.8.x -> 0.9.x

Start-up sripts should be updated to use the new cluster discovery syntax (See:
https://docs.storageos.com/docs/install/prerequisites/clusterdiscovery)

Do not mix a cluster with 0.8.x and 0.9.x versions as port numbers have changed.
This may cause cluster instability while nodes are being upgraded.

### 0.7.x -> 0.8.x

Due to the nature the KV Store change there is no upgrade method from 0.7.x to
0.8.x+.  Our recommendation is to create a new cluster, paying attention to the
new parameters (`CLUSTER_ID` and `INITIAL_CLUSTER`).  Note that `CLUSTER_ID` and
`INITIAL_CLUSTER` have been replaced by `JOIN` in 0.9.x onwards.

## 0.9.2

The 0.9.2 fixes a memory leak, so upgrading is recommended.  It also reduces
the time taken to delete volumes.

More work has gone into logging, with API endpoints to control verbosity and
log filtering of running nodes individually or cluster-wide.  Version 0.9.4 of
the CLI provides the `storageos logs` subcommand to control settings remotely.

### New

- API endpoints for logging configuration

### Improved

- Remove cgo dependencies from controlplane
- Better error message when the KV store is unavailable
- Reduced memory footprint of controlplane by 67%.

### Fixed

- Memory leak introduced in 0.9.0 fixed

## 0.9.1

The 0.9.1 release includes a fix for the `mount deadline exceeded` error, where
a volume mount fails after a long delay.

The logging susbsystem has also been overhauled to reduce noise and to allow
filtering messages by log level and component.  We expect to build on this in
upcoming releases to further improve diagnostics.

### New

- Failure modes can be specified to control behaviour in specific failure
scenarios.  Full documentation to be added to the docs site soon.

  - `hard` will enforce the desired number of replicas and take a volume offline
    if the replica count is not met.  In practice, the volume should only go
    offline if there isn't a suitable node to place a new replica on.  For
    example, if you have configured 2 replicas in a 3 node cluster and a node
    goes offline.
  - `alwayson` will optimise for availability and will keep a volume online even
    if all replicas have failed.
  - `soft` is set by default, and will only take a volume offline if the number
    of replicas falls below the Failure tolerance (default: number of
    replicas - 1).  This will allow a volume with 2 replicas in a 3 node cluster
    to remain active while a node reboots.

  You can select the failure mode through the labels:

    ```bash
    storageos volume create --label storageos.com/replicas=2 --label storageos.com/failure.mode=alwayson volume-name
    ```

- Log filtering allows finer-grained control of log messages so that debug-level
  messages can be enabled only on some components.  Filtering is controlled by
  setting `LOG_FILTER=cat1=level1,catN=LevelN`.  For example, to enable
  debugging on only the etcd category:
  1. Set `LOG_LEVEL=debug` to enable debug logs.  This must be set to the lowest
     level requested in the filter.
  1. Set `LOG_FILTER=cp=info,dp=info,etcd=debug` to set controlplane and
     dataplane logs back to `info` level, then `etcd` to `debug`.
- Enabled profiling of the controlplane when DEBUG=true is set.  The endpoint is
  availble at http://localhost:5705/debug/pprof.
- Debug endpoints to monitor and control KV store leadership (DEBUG=true must be
  set).

  - HTTP GET on http://localhost:5705/debug/leader returns true/false if the
    node is the cluster leader.
  - HTTP PUT on http://localhost:5705/debug/leader/resign will cause leader to
    resign, triggering a new election.
  - HTTP PUT on http://localhost:5705/debug/leader/run will cause node to run
    for cluster leadership.

  These actions are used primarily for automated testing where we introduce instability into the cluster to ensure there is no service disruption.


### Improved

- More instructive log messages if unable to create filesystem.
- Improve check for whether a device is using NBD for presentation.
- Log whenever a dataplane process restarts.
- Updated etcd libraries to v3.3.0-rc.0.
- Etcd tuning (TickMs = 200, ElectionMs = 5000)
- Updated other dependencies to latest stable releases.
- Dataplane, etcd, gRPC and NATS now use same log format as the controlplane.
- More user-friendly error message when `ADVERTISE_IP` is invalid.

### Fixed

- Fixed a bug that caused mounts to fail with `Failed to mount: exit status 32`.
  This was caused by the volume being marked as ready before the device was
  fully initialised, and the mount starting before the initialization completed.
- Volume names are no longer lowercased and keep the requested case.  This
  fixes an issue with Docker EE with mixed-case volume names.
- Volume delete on non-existent volume now returns HTTP 404 instead of 500.
- Do not reset node health if internal healthcheck returns invalid response.
  Instead, retry and wait for valid response message.

## 0.9.0

This release focusses on usability and backend improvements.  It builds on the
embedded KV store from 0.8.x and improves the bootstrap process.

Enhanced stress testing and performance benchmarking have also led to a number
of improvements and better failure handling and recovery.

### Deprecation notices

While in Beta there may be changes that break backwards compatibility.  GA
releases will strive to preserve compatibility between versions.

- The `INITIAL_CLUSTER` and `CLUSTER_ID` environment variables have been
  replaced with `JOIN` and they should no longer be used to bootstrap a new
  cluster.  `JOIN` provides a more flexible mechanism for creating new clusters
  and expanding existing clusters.  Errors or deprecation notices in the log at
  startup will help verify that the correct environment variables are used.
- The API object format for users has changed to make it consistent with other
  objects.  Version 0.9.0+ of the StorageOS CLI must be used to manage users on
  a version 0.9.x cluster.

### New

- Cluster can now start as soon as the first node starts, and any number of
  nodes can join the cluster.  The `JOIN` environment variable replaces
  `CLUSTER_ID` and `INITIAL_CLUSTER` and is more flexible, allowing
  administrators to combine methods for bootstrapping and discovering clusters.
  See https://docs.storageos.com/docs/install/prerequisites/clusterdiscovery
- Online replica sync for new and replacement replicas.  This allows for writes
  to complete on the required number of replicas immediately instead of
  waiting for a new replica or a replacement replica to be fully synced.
- Network ports now use a contiguous range (5701-5711/tcp, 5711/udp)
- State-tracker added to frontend filesystem.  This allows greater flexibilty
  for backend failure recovery.
- Prometheus endpoint for exposing internal metrics.  This version includes
  API usage metrics, but will be extended in an upcoming release to include
  detailed volume, pool and node metrics.
- Reports are sent to Sentry if processes within the StorageOS container are
  stopped unexpectantly.  These reports help us improve the stability of the
  product, but they can be disabled by setting the setting the
  `DISABLE_TELEMETRY` environment variable to true.

### Improved

- Enforced ordering for some types of read/write operations to ensure
  deterministic behaviour
- Ensured all components shutdown cleanly in normal situations and recover
  properly when clean shutdown not done.
- Added gRPC to dataplane for synchronous internal messaging
- User API endpoint now has a format consistent with other endpoints.  `/users`
  now returns a list of users, and a POST/PUT to `/users/{id}` accepts a user
  object.
- Document minimum server requirements
- Document node selector for volume create operations
- Document quality of service (QoS) and protection from noisy neighbors
- Document volume placement hints
- Separate usage metric endpoints for internal (Dev/QA) and release (Public)
- Health endpoints show `changedAt` and `updatedAt` to help detect flapping
  services
- Unmount volumes through CLI and API
- Removed false-postive errors and warning from logs
- Improve signal handling
- `LOG_LEVEL` passed to dataplane components

### Fixed

- Clear mount lock after ungraceful node shutdown
- etcd error: `mvcc: database space exceeded`
- NBD cleanup during ungraceful node shutdown
- No longer possible to have two default pools
- `storageos cluster health` did not return useful information while the cluster
  was bootstrapping
- Node master and replica statistics were not getting updated after a node
  failure

### Known issues

- It is currently not possible for a node to leave the cluster completely.  If
  the StorageOS container is stopped and/or removed from a node then the node
  will be detected as failed and it will be marked offline, but there is no way
  to remove the node from the list.  `storageos node rm` will be added before GA
  along with `storageos node cordon` to disable scheduling new volumes on the
  node, and `storageos node drain` to move volumes to other nodes prior to
  maintenance or removing the node from the cluster.
- `storageos volume mount <vol> <mountpoint>` does not work on Managed Plugin
  installs.  Volumes mount into containers correctly using Docker.
- Docker can only access volumes created in the `default` namespace.
- Clients mounting volumes from RHEL7/CentOS 7 will experience degraded
  performance due to the absence of the
  [nbd kernel module]({%link _docs/install/prerequisites/devicepresentation.md %}) on those
  platforms.

## 0.8.1

### Improved

- NBD device numbers now start at 1 instead of 0 to defend against default values

## 0.8.0

This is our first feature release since launching our public beta, and it
focusses on feedback from users.  As always, please let us know how you are using
StorageOS, what problems it is solving for you and how it can improve.  Join our
[Slack channel!](http://slack.storageos.com)

### New

- Embedded KV Store based on etcd to further simplify deployment and ongoing
  cluster management.  Support for external Consul KV clusters has been
  deprecated, though external etcd clusters are now possible, but not yet
  documented and supported.
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

### Improved

- Graceful behaviour when communication blocked by firewalls
- Docker integration now supports ext2/3/4, btrfs and xfs
- Environment variable validation
- Selectors for rules
- Use default namespace when not specified
- Internal volume performance counters
- API can report health while waiting for cluster to initialize

### Fixed

- Better behaviour when communication blocked by firewalls
- Ensure namespaces are unique when creating
- Volume create should give error when size=0
- CLI/API filters not working as expected
- Can't edit a pool with the CLI
- Excessive logging on network timeouts

### Known issues

- Once a 0.8.0 cluster has been established, it is currently not possible to add
  or remove members.  We expect this functionality to come in 0.8.1, and welcome
  feedback on how this should behave.
- `storageos volume mount <vol> <mountpoint>` does not work on Managed Plugin
  installs.  Volumes mount into containers correctly using Docker.
- Docker can only access volumes created in the `default` namespace.
- Clients mounting volumes from RHEL7/CentOS 7 will experience degraded
  performance due to the absence of the
  [nbd kernel module]({%link _docs/install/prerequisites/devicepresentation.md %}) on those
  platforms.

## 0.7.10

This release continues our focus on stability and better test coverage across a
growing suite of platforms and usage scenarios.

### New

- Keepalives for replication though firewalls

### Improved

- Graceful shutdown internal cleanup
- User authentication internals made extensible to other auth providers
- Internal changes to allow different log levels per module

### Fixed

- Removed log entries where events are raised and logged again
- Consolidated log messages when KV store is not available

## 0.7.9

### New

- Maintenance mode to allow partial startup when the KV store is not ready

### Improved

- Better write parallelization performance

### Fixed

- Issue with volume deletion

## 0.7.8

### New

- Node statistics reporting
- Compression (in-transit and at-rest) enabled by default

### Improved

- Refactored startup process
- Better volume distribution across cluster
- Relaxed volume naming requirements to support Docker dynamic volumes
- More instrumentation counters for volume stats
- Improved data plane error handling and retry logic
- Replication enhancements
- Ongoing log-level tuning to reduce noise

### Fixed

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

