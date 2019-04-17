---
layout: guide
title: StorageOS Docs - Release notes
anchor: reference
module: reference/release_notes
---

# Release Notes

We recommend always using "tagged" versions of StorageOS rather than "latest",
and to perform upgrades only after reading the release notes.

The latest tagged release is `{{ site.latest_node_version }}`, available from
[Docker Hub](https://hub.docker.com/r/storageos/node/) as `storageos/node:{{
site.latest_node_version }}`, or via the [Helm
Chart](https://github.com/storageos/charts)

The latest CLI release is `{{ site.latest_cli_version }}`, available from
[Github](https://github.com/storageos/go-cli/releases)

# Upgrading

See [upgrades]({%link _docs/operations/upgrades.md %}) for upgrade strategies.

## 1.2.0-rc1 - Released 12/04/2019

**The `1.2.0-rc1` release notes are provisional, with further updates and
documentation expected before `1.2.0` is released.**

### New

- Pod fencing can improve application failover times, particularly for
  applications deployed as StatefulSets.  When the label
  `storageos.com/fenced=true` is applied to a Pod and StorageOS detects that
  the node running the Pod is offline, it will tell Kubernetes to re-schedule
  the Pod elsewhere.
  
  Without this feature, Kubernetes will by default wait 5 minutes before marking
  the node offline and performing remedial actions.  When applications are
  deployed as StatefulSets then manual confirmation is also required before Pods
  will be re-scheduled.  This behaviour guards against multiple nodes accessing
  the same volume concurrently as Kubernetes does not have visibility of the
  storage presentations.

  Since StorageOS detects and remediates node failure more aggressively (in
  30-40 seconds) and it protects against multiple nodes accessing volumes
  concurrently, the fencing option gives the ability to override the default
  Kubernetes behaviour.

- Encryption at rest.  See upcoming documentation and blog post.

- Mutual TLS is now supported on external etcd KV backends.

### Improved

- Multiple significant performance improvements.
- Multiple data plane processes were merged into a single `dataplane` binary.
  This has multiple benefits:

    - Improved performance by reducing context switches when passing data
      between processes.
    - Easier to instrument and trace.
    - Startup and shutdown logic simpler to manage.

- DirectFS, the network communication layer used by replication and remote
  volumes, has been largely re-written and now uses a connection pool to reduce
  memory overhead.
- Several log formatting and level improvements to provide more relevant and
  consistent messages.

### Fixed

- Multiple fixes, details to be provided before `1.2.0` final release.

## 1.1.5 - Released 29/03/2019

Version 1.1.5 is an interim bugfix release as we continue to test the upcoming
1.2 feature release internally.

### Improved

- Previously we would allocate 5% of free memory to use as cache. On larger
  systems that were being rebooted, we could use more memory than intended if we
  start before other applications do. We now set a hard upper-bound of 512MB.
- The cluster ID is now logged more prominently during startup.
- Labels prefixed with `kubernetes.io/` are now accepted. This allows core
  Kubernetes labels to be inherited and used for scheduling decisions.
- A cache flush is now triggered when `fsck` is run on a volume.
- Removed noisy log messages from the dataplane stats module.
- Increased log level to `info` for volume create and delete with CSI.

### Fixed

- Mounting a volume while the volume was undergoing a series of configuration
  updates could cause the mount to hang.
- When increasing the number of replicas for a mounted volume, the new replica
  could get stuck in "provisioned" state. Removing the stuck replica and
  re-trying would normally clear the issue. The root cause has now been fixed.
- When a volume was being deleted and the data scrub finished, if there was an
  error removing the volume configuration from the kv store (e.g. kv store
  unavailable), it would log an error and not retry. Now, the operation is
  re-tried.
- The soft and hard mode failure detection was incorrectly using the count of
  failed replicas in the calculation, not the active replicas. When new replicas
  are being provisioned it's normal to have more than the requested number of
  replicas with some of them pending removal. The logic was changed to count
  healthy replicas instead.
- Fixed excessive log messages when removing a device for a volume that still
  exists elsewhere in the cluster.
- The UI incorrectly counted the replica stuck in "provisioned" state as
  available when it did not yet have a consistent copy of the the data.
- When setting the cluster log level via the CLI, an error was returned even
  though the update suceeded.
- The UI was displaying storage capacity in GB rather than GiB.
- In the UI, the volume delete hover was missing, causing the button to appear
  disabled.
- Adding a label to a volume in the UI could insert the string "undefined".

## 1.1.4 - Released 06/03/2019

Includes a single fix to increase the time we wait for the operating system to
create a new block device.  On some platforms (cloud providers in particular)
the variation can be wider than expected.

### Fixed

- Address device creation delays on certain platforms/distributions.

## 1.1.3 - Released 01/03/2019

Version 1.1.3 is a bugfix and usability release.  Please upgrade if you are
using external etcd.

### New

- There are no new features.  Look out for 1.2 coming soon!

### Improved

- When using an external etcd KV store and it becomes inaccessible, StorageOS is
  now more resilient.  All volumes remain online and usable but configuration
  changes are restricted.
- Added a warning in the UI if cluster nodes are running different StorageOS
  versions.  The warning includes a link to the upgrade documentation.
- The cluster ID is now more prominent in the UI.  The cluster ID is required
  for licensing and support.
- UI login failure notifications are now automatically dismissed after a
  successful login.
- Improved error handling and logging when configuring volumes in the data
  plane.
- Strict dependency checking when configuring volumes.

### Fixed

- When refreshing the volumes page in the UI could return a "volume not found"
  error.
- When editing volume labels in the UI, there is now a confirmation check before
  removing a label.
- Fixed a bug that might prevent a volume delete request from being actioned.
  This would appear as a volume that is stuck in deleting state.

## 1.1.2 - Released 03/02/2019

1.1.2 improves stability when nodes lose network connectivity intermittenly by
introducing a new grace period before performing node recovery operations.

## Breaking changes

The environment variables introduced in version `1.1.1` to tune node failure
detection have changed. Previously `PROBE_INTERVAL_MS` and `PROBE_TIMEOUT_MS`
were set to a number of milliseconds.  They have now been replaced with
`PROBE_INTERVAL` and `PROBE_TIMEOUT`, which takes a time duration in string
format, e.g. `500ms` or `2s`.  We believe this change gives slightly more
flexibility and is easier to use.  Going forward, all duration-based
configuration will use this format.

### New

- When network connectivity to a node is confirmed lost, there is now a
  configurable grace period before recovery operations begin.  The grace period
  allows time for the network or node to recover from short interruptions.  The
  default is set to `30s`.  The minimum duration is `0s`, and the maximum is
  `90s`.
- In the UI, a button has been added to re-send the activation email when
  requesting a Developer licence.

### Improved

- Logs now use nanosecond precision for timestamps.  This helps ensure the
  correct ordering when logging to an external source such as Elasticsearch.
- Upgraded Golang compiler to version `1.11.5`.
- Support diagnostics can now be generated while nodes are waiting to join the
  cluster.  This can help troubleshoot dependency or network connectivity issues
  that are blocking successful startup.  This feature is currently only enabled
  in the API; in a future release it will be exposed in the UI and CLI.  To
  generate the diagnostics bundle, run:

  ```bash
  curl -o diagnostics.tar storageos:storageos@localhost:5705/v1/diagnostics/cluster
  ```

- Added more context to error logs when there is a failure to configure the
  dataplane.
- Added more logging at debug level when gossip detected a node's health change.


### Fixed

- When CSI is enabled, if a volume was created in a namespace that did not
  already exist, then the create operation would fail.  Now the namespace is
  created as part of the volume create operation.  This matches the behaviour of
  the Kubernetes native driver.
- When importing Kubernetes ABAC policy files, the jsonl format was incorrectly
  detected and input was incorrectly parsed as json, which would not validate.

## 1.1.1 - Released 21/01/2019

1.1.1 contains a critical bugfix in the etcd client library that could cause
the StorageOS control plane to become unresponsive when etcd is unavailable.

### New

- Exposed tuning knobs for node failure detection via two new environment
  variables:

  - `PROBE_INTERVAL_MS`: the interval in milliseconds between node probes.
    Setting this lower (more frequent) will cause the cluster to detect failed
    nodes more quickly at the expense of increased bandwidth usage.  Defaults to
    1000ms.
  - `PROBE_TIMEOUT_MS`: the timeout to wait for an ack from a probed node before
    assuming it is unhealthy.  This should be set to 99-percentile of RTT
    (round-trip time) on your network.  Defaults to 3000ms.

  The defaults should be appropriate for most environments.

### Improvements

- If a node is determined to be offline by [memberlist](https://github.com/hashicorp/memberlist),
  we now verify by sending a TCP handshake from the scheduler to the node's
  replication port.  If the handshake is successful we abort the process to mark
  the node offline.
- If the StorageOS container was killed, we now log at error level instead of
  debug level.
- The UI now gives user feedback when a diagnostics bundle is being uploaded or
  downloaded.
- Volume details and `dmesg` output is now collected in the diagnostics bundle.
  This information helps our engineers diagnose issues more easily.
- Internal cleanup of API handlers and middleware.  API errors now follow
  consistent formatting.
- Values for CSI parameters `VolumeId` and `VolumePath` are now validated to
  ensure they are not empty.  This is internal to the interaction between
  the orchestrator and StorageOS and applies to the `GetVolumeStats()` CSI call.
- Removed spammy "failed to retrieve volume capacity stats" log message when a
  volume was in the process of being deleted.
- When a node is rebuilt and re-added to the cluster, manual steps must be taken
  to ensure that a previous (now invalid) config is not re-applied to the new
  node as it may not have the previous backend data.  The log messages now
  better explain the issue and the steps required to resolve.
- Better error logging when data plane configuration was not applied.

### Fixed

- Updated the etcd client library to version 3.3.11, which includes a fix for
  https://github.com/etcd-io/etcd/issues/9578, a tight loop in the reconnect
  logic when a watch loses its connection to the etcd server.  The loop would
  cause the control plane to become unresponsive, including not allowing it to
  respond to healthchecks, which could result in the node being taken offline.
- Fixed an issue in the etcd watcher when we specify an object version to
  use as a starting point to watch for change from, but that version no longer
  exists in etcd due to scheduled compaction of the etcd datastore.  Now, the
  error is caught and retried from the latest version.  The error was logged as:
  `etcdserver: mvcc: required revision has been compacted`.
- The diagnostics bundle was saving with the extension `.tar.gz`, even though
  it is not compressed.  It now saves as `.tar`.
- When a node was heavily loaded, it was possible for volume delete requests to
  get stuck.  The delete result processing is now done in a separate thread from
  the request so that a long request can't block receiving responses.

## 1.1.0 - Released 04/01/2019

1.1.0 adds support for [CSI 1.0](https://github.com/container-storage-interface/spec)
and includes some minor bug fixes.

### New

- CSI 1.0 (available in Kubernetes 1.13 onwards) is now fully supported.
  Backwards compatibility with earlier versions of CSI and Kubernetes has been
  maintained and is the default.  CSI 1.0 support is automatically enabled when
  using the StorageOS [cluster-operator](https://github.com/storageos/cluster-operator)
  on Kubernetes 1.13 and above.  If installing manually, set the `CSI_VERSION`
  environment variable to `v1`.

### Improvements

- In the UI, the namespaces in the dropdown list are now sorted in alphabetical
  order.
- Removed spammy log messages for IO size.
- When creating a volume using CSI, the namespace can be set by adding a
  `volumenamespace` label to the StorageClass.

### Fixed

- Cloud provider detection could cause a panic in non-AWS environments that
  respond on the same metadata ip address that AWS uses.  Fixed in
  [aws-sdk-go](https://github.com/aws/aws-sdk-go/pull/2380).
- Refreshing the UI caused the selected namespace to be reset.

## 1.0.2 - Released 10/12/2018

1.0.2 includes a fix required for Azure AKS and several other fixes and
improvements, many to help with running on low-memory or heavily loaded servers.

### Improvements

- Cache allocation has been adjusted for lower memory systems.  Allocation sizes
  are described in [architecture]({%link _docs/concepts/architecture.md %}).
  The cache size will never be set to more than 1/3rd of free memory.
- Increased the maximum number of replicas from 4 to 5.
- Increased the timeout for the device presentation shutdown to 9 seconds before
  sending a `SIGKILL`.
- Increased the wait timeout for dataplane startup from 10 to 30 seconds.  
- Added colour-coded health labels in the UI.
- Rules can now be enabled and disabled in the UI.
- Improved input validation in the UI.
- IO error handling log messages are now more informative.

  Non-fatal (re-tryable) errors:

  - `Can't resolve replica inode configuration on local director`
  - `Can't resolve master inode configuration on the remote director`
  - `Can't resolve replica inode configuration on the remote director`
  - `The client does not have the appropriate configuration`
  - `No connection could be found`

  Fatal errors:

  - `Generic fatal error (use this if there is no need to be specific)`
  - `Can't resolve master inode configuration on the local director`
  - `ENOSPC error`
  - `Blobs corrupt/missing/not-sane etc`
  - `A shm-pipe operation fatally failed`
  - `Read only volume`
  - `Sentinel value`

- Corrected confusing log message: `poll() returned error on network socket: Success`.
  We now log: `connection closed`.
- Better logging when testing system device capabilities.
- Better logging for dataplane status errors.

### Fixed

- On Azure AKS, StorageOS could fail to restart.  This was caused by an error in
  the system device capabilities verification incorrectly determining that the
  node didn't meet prerequisites.
- During startup, it was possible to retrieve an uninitialized value from a
  dataplane status endpoint, which caused startup to fail.  This was only seen
  on heavily-loaded systems.
- Potential deadlock in dynamic cache resize.  This is not known to have
  occured.
- During a scheduler failover, it was possible to miss a node recovery gossip
  message and the node would never be marked as recovered.
- It was possible for a volume to get a volume stuck in `syncing` state if a KV
  watcher was interrupted.  Now, full state from the KV store is re-evaluated
  every 10 seconds.
- When creating a volume using CSI, the pool field was ignored.

## 1.0.1 - Released 23/11/2018

This is primarily a bugfix release to better handle node recovery behaviour when
network connectivity is re-established.  There are also a few minor bugfixes and
general improvements.

### Improvements

- Upgraded UI to use [Vue CLI 3](https://cli.vuejs.org/).
- It is no longer possible for a user to delete their own account, or for an
  administrator to downgrade their access to a normal user.  This ensures that
  there is always at least one cluster administrator.
- When making volume placement decisions, the scheduler will now apply a lower
  ranking score to nodes that have come online less than 5 minutes ago.  This
  allows the node to perform most recovery operations prior to accepting new
  volumes.  This will not cause volume placement to be delayed, only that
  non-recovering nodes will be preferred.
- The cluster diagnostics bundle can now be downloaded via the Web UI in
  addition to uploading for StorageOS support.
- The volume list in the Web UI now shows more detailed volume health.
- Dataplane metrics now use less memory.

### Fixed

- If a node was partitioned as a result of a network failure, it would not
  always rejoin the cluster when the network was restored.  Nodes now
  attempt to reconnect via gossip every 2 seconds.
- Dataplane process metrics (e.g. memory usage) were not being exposed via
  the Prometheus `/metrics` endpoint.
- `storageos logs -f` CLI command was incorrectly reporting all log entries at
  `fatal` level, overwriting the correct log level.
- Fixed errors in Web UI when API not yet available.

## 1.0.0 - Released 15/11/2018

1.0.0 is suitable for production workloads.

### New

- Offline nodes can now be removed from management either by using the CLI `node
  delete` command, or in the UI. This is only available when external etcd is
  used as the KV store.  See
  [decommissioning nodes]({%link _docs/operations/decommission-nodes.md %})
  for more information.
- Nodes can now be placed into "Maintenance mode" to disable volume recovery on
  the node while it is offline for maintenance. This allows nodes to be
  upgraded without triggering potentially unwanted data migrations. Note that
  applications accessing StorageOS volumes on the node should also be shutdown.
  Alternatively, you may move applications off the node and use
  `stoageos node drain` to migrate data prior to taking the node offline.
- 5% of backend volume capacity is now reserved for indexes and recovery.  This
  helps ensure that there is enough remaining capacity to perform recovery
  operations such as deleting or moving frontend volumes.
- Prometheus metrics for volume used capacity, and added to the API volume
  objects and the UI. A placeholder for actual used capacity (after
  compression) has also been added but is not yet provided.
- In the UI, storage pools and nodes now have an additional details page.
- Added group management to the UI.
- The overprovisioning ratio can now be configured on pools by applying the
  label `storageos.com/overcommit` to a positive integer representing the
  overcommit percentage. By default, overcommit is set to 0.
- At startup and every 24 hours, each cluster will make a DNS request to query
  the latest StorageOS version and log if a new version is available.  The UI
  will also notify administrators.  This check can be disabled by setting
  `DISABLE_TELEMETRY=true`.  For more information see
  [telemetry]({%link _docs/reference/telemetry.md %}).
- Since data scrub operations can be intensive, we now limit to 5 concurrent
  volume scrubs.  This does not affect the number of volumes that may be deleted
  in a batch as the scrubs occur asyncronously.  Volumes will remain in
  `deleted` state until the data is scrubbed, then they will not be reported at
  all.

### Improved

- Updated Prometheus metrics names to follow best practices.
- Added process name to dataplane log messages.
- Removed excessive heartbeat messages from debug logging.
- Removed an unneeded mutex from the dataplane debug logging.
- Added protection against a potential hard hang while cleaning up devices by
  instructing the kernel to abort any IO on the device prior to removing.
- Add `createdAt` and `updatedAt` fields in volume replica API objects.
- All API errors now return JSON content type (content remains the same).
- UI improvements to remember state when validation fails.
- UI feedback and help text while requesting a developer licence is more
  intuitive.
- Better error message when manually applying an invalid licence.
- Volume detail page in the UI has numerous improvements to improve usability,
  including on smaller screen sizes.
- When the UI was accessed before the node was fully online it would show a
  blank page. It now shows the message `Cluster API not yet available, waiting
  for nodes to join`.
- The browser "back" button on the UI now works as expected.
- Label management in the UI now gives context-sensitive examples and improves
  validation.
- Added network diagnostics and Prometheus metrics to support diagnostics
  bundle.
- Updated container labels.

### Fixed

- When a replica is auto-promoted to master because the application container
  moved, a cache reset for the volume is now triggered prior to updating the
  presentation to ensure the cache can never serve stale data.
- Fixed a crash in the replication server during shutdown when a volume scrub
  operation was taking place on a deleted volume with a non-trivial amount of
  data.
- In a cluster with hundreds of volumes and nodes continuously rebooting, a race
  condition could cause a volume to be "stuck" in syncing state if the sync
  started before the dataplane was ready for operation.  New replicas are now
  created with their health set to `provisioned`, and only enter the `syncing`
  state once the sync is underway. This allows the operation to be retried if
  required.
- After a restart, a write pointer was starting at the end of the current 64MB
  chunk. This would waste space if the chunk was not fully used. The pointer
  is now set to the end of the written data to ensure full utilisation.
- Check-and-set operations in the internal key-value store library were not
  honouring the TTL requested. This could cause CAS updates to fail when there
  was above average latency between nodes.
- If a non-admin user tried to cordon/drain a node in the UI it would fail
  silently. Now the action is disabled for non-admins and the API returns the
  correct error.
- In the UI, if a previous licensing operation failed, cached data could make it
  difficult to re-request a licence.
- If a volume was requested but failed due to validation (e.g. not enough
  capacity), it would be marked as `failed` and an attempt to re-create would
  fail with the message `Volume with name 'foo' already exists`. Now the second
  operation will replace the first and will be re-evaluated.
- After startup, pool capacity would only be calculated after the API was ready
  for use.  This caused provisioning requests immediately after startup to fail.
  Capacity is now calculated prior to the API accepting provisioning requests.
- Slow/broken DNS responses could cause cloud provider detection to delay
  startup for up to 30 seconds while waiting for a timeout.
- Cluster health CLI and API endpoint no longer report an error when external
  etcd is used for the KV store.
- When creating new users, usernames are now validated to disallow names in the
  UUID format used internally.
- In the UI, non-admin users can now view and update their information,
  including changing their own password.
- Password resets now work correctly and can be used to create a licence for a
  portal account that was created with a social login.
- If there was an error deleting a rule, the API returned an Internal Server
  Error rather than a more helpful contextual error.

## 1.0.0-rc5 - Released 01/10/2018

1.0.0-rc5 is a major update, with multiple bug fixes, performance and usability
improvements as we get closer to removing the RC label.

### Breaking changes

- Between rc4 and rc5 the location of the lock that governs configuration
  changes has moved.  For maximum safety, shutdown StorageOS on all nodes
  prior to upgrading to rc5.  If this is not feasible, contact
  support@storageos.com for further instructions.
- Prometheus metric names and types have changed to adhere to best practices.
  If you have existing dashboards they will need to be updated.

### New

- User, group and policy management added to the Web UI.
- A custom or self-hosted cluster discovery service can now be specified by
  setting the `DISCOVERY_HOST` environment variable to the hostname or ip of the
  running service.  The source code for the discovery service is open and
  available on [GitHub](https://github.com/storageos/discovery).  Note that the
  cluster discovery service is optional and supplied as a convenience.
- The `KV_ADDR` environment variable now supports specifying multiple hostnames
  or addresses of external etcd servers.  Hostnames and addresses should be
  comma-separated and can include the port number (required if not `2379`, the
  etcd default).
- Passes CSI 0.3 (latest) [conformance tests](https://github.com/kubernetes-csi/csi-test).
- RHEL/Centos has a limit of 256 devices per HBA.  The API now returns
  `cannot create new volume, active volumes at maximum` when this limit has been
  reached.
- New network connectivity diagnostics to help diagnose potential firewall
  issues.  With the CLI (`storageos cluster connectivity`) or API
  (`GET /v1/diagnostics/network`), all required connectivity will be verified.
- Without a licence, StorageOS has all features enabled but provisioned capacity
  is now limited to 100GB.  Once registered (for free, via the Web UI), capacity
  increases to 500GB.

### Improved

- Increased overall performance by reducing context switches in the IO path,
  resulting in lower latency for all IO.
- Increased replication performance by optimising the parallel writes to
  multiple destinations.  With >1 replicas this will roughly double replication
  performance, but it also reduces the overhead of adding additional replicas to
  a volume.
- Time taken to detect and recover from a node failure reduced from 45-70
  seconds to <15 seconds.
- Improved the internal distributed lock mechanism to ensure correct and
  deterministic behaviour in the majority of failure scenarios.
- Implemented basic check-and-set (CAS) on control plane operations where
  consistency is required.
- Stop all control plane state evaluations if KV store is unavailable for more
  than the distributed lock TTL (5 seconds).
- Ensure node does not participate in state evaluations when it has been set as
  unschedulable with `storageos node cordon` or `storageos node drain`.
- Internal library change from [Serf](https://github.com/hashicorp/serf) to
  [Memberlist](https://github.com/hashicorp/memberlist).  This helps simplify
  node failure detection.
- Control plane state evaluations are now performed serially with an interval of
  once per second.  This reduces the load on the cluster during bulk or recovery
  operations.  Previously, multiple workers may try to apply the same changes,
  causing unnessessary validation to take place.  A Prometheus histogram has
  been added to track duration of each state evaluation.  Under normal operation
  it takes 10-50ms.
- Node capacity now includes capacity from all devices made available for use by
  StorageOS.
- Volume health management and reporting is improved.  Health is now defined as:

  - `healthy`: Only if the volume master and requested number of replicas are
    healthy.
  - `syncing`: If any replicas are in the process of re-syncing.
  - `suspect`: The master is healthy, but at least one replica is suspect or
    degraded.
  - `degraded`: If the master is suspect/degraded or the master is healthy
    but at least one replica is dead.
  - `offline`: If the volume is offline, typically because the master is not
    available and there were no healthy replicas to failover to.
  - `decommissioned`: If a volume is being deleted the health will be marked as
    decommissioned.

- Prometheus metrics have been overhauled to provide more friendly and useful
  statistics.
- Internal library change from [vue-resource](https://github.com/pagekit/vue-resource)
  ([deprecation notice](https://medium.com/the-vue-point/retiring-vue-resource-871a82880af4))
  to [Axios](https://github.com/axios/axios) for handling ajax requests in the
  Web UI.
- Warnings are now logged when volumes can not be provisioned due to licensing
  constraints.
- Internal logging improvements to ensure that runtime changes to log levels or
  filters maintain consistency across multiple consumers.
- Diagnostic requests now support JSON requests via the "Accepts" header,
  defaulting to the current tar archive response.  Internally, collection from
  multiple nodes is now streamed with a timeout of 10 seconds to prevent an
  unresponsive node from blocking the response.
- Improved description and flow of cluster diagnostics upload.
- Web UI volume detail page re-designed.
- Web UI theme tweaks: list view, pagination, headers, in-place edit.
- Upgrade version of internal messaging library (nats) and restructure
  implementation.
- Ensure the API supports label selectors on all object listings and improve
  internal code consistency and tests.
- Ensure control plane workers and gRPC connection pool are shutdown cleanly
  prior to shutting down the data plane to ensure operations have completed and
  to reduce warnings in logs.
- Explicitly shutdown the data plane gRPC handlers in the replication client
  prior to shutting down the rest of the data plane.  This protects against a
  potential issue that could lead to unclean shutdown.
- The lun ID is now computed dynamically.  This allows support for devices 
  across multiple HBAs in the future, which will remove the limitation of 
  256 volumes on RHEL7/Centos7 clusters and other systems with kernel 3.x.
- SCSI lun support now supports co-existence with other block storage providers
- Bulk volume creation could cause excessive validation warning messages in the
  logs do to concurrent configuration requests to the data plane.  Now, if the
  volume already exists or a CAS update fails, a conflict error (rather than
  generic error) is returned to the control plane.  This allows the control
  plane to only log a warning or error message if the intended action failed.
- Ongoing log message readability and tuning of log levels.

### Fixed

- Filesystems now behave correctly when the underlying data store is out of
  capacity.  Previously the filesystem would appear to hang as it would retry
  the operation indefinitely.  Now, the filesystem will receive a fatal error
  and will typically become read-only.
- Listing volumes bypassed policy evaluation so a user in one namespace was able
  to view volume details in another namespace.  Create, update and delete were
  not affected and required correct authorization.
- Deletion of encrypted volumes did not work correctly.
- Product version details were not always displayed correctly.
- Licence upload could fail with error: `licence and actual array UUIDs do not
  match`.
- Erroneously reported an error when removing data for a volume that was already
  deleted.
- Web UI icons no longer load from the Internet and now display in disconnected
  environments.
- Web UI capacity now uses gigabytes to be consistent with CLI.
- API error when running `storageos cluster health` was suggesting to use
  `storageos cluster health` to diagnose the errror.
- API for retrieving the Cluster ID is no longer restricted to administrators
  only, but any authenticated user.
- Rules against namespaces with common prefixes no longer clash.
- It was possible to create more than one namespace with the same name.
- Fixed `fork/exec /usr/sbin/symmetra: text file busy`, caused by the operating
  system not having closed the file for writing before it is executed.
- Fixed `docker volume rm <volname>` returning 0 but not deleting the volume
  correctly.
- If a volume has a single replica and the master fails when the replica is in
  `syncing` state, the volume is now marked as `offline` until the master
  recovers.  Previously, the volume remained in `syncing` state indefinitely.
- If a volume with no replicas goes offline and then recovers, the volume was
  not marked as `healthy`.
- The CLI was reporting replicas that were not active, creating inaccurate
  volume counts.
- On a new volume with no replicas with the master on node1, if the volume was
  mounted on a node that does not hold the volume master (node2) and then node1
  drained, then the new volume created on another node will not be mountable.
- Prometheus `/metrics` endpoint always returns text format with correct text
  encoding, even if binary output was requested.  This matches the Prometheus
  2.0 policy to deprecate the binary format, and allows the endpoint to work
  with other collectors that support the text format, e.g. Telegraf.
- Fixed an unclean shutdown issue in the data plane volume presentation where
  configuration of a volume could still be attempted while a shutdown was in
  progress.  A lock is now taken to ensure order and to refuse configuration
  while a shutdown is in progress.  This only occured during shutdown and did
  not affect data consistency.
- Fixed an unclean shutdown issue in the replication client where references to
  the client configuration could be cleared while IO was still in progress.  A
  reference counter has been implemented to ensure that all operations have
  completed prior to the server entry being removed.  This only occured during
  shutdown and did not affect data consistency.
- Ensure all internal IO acknowledgements are received or a timeout reached
  prior to shutting down the replication server.  This fixes an issue where
  a shutdown or fatal error could cause the server to crash as it was being
  shutdown cleanly.  This only occured during shutdown and did not affect data
  consistency.
- Fixed an issue in the replication client connection handler that in some
  situations could allow the client to re-use a connection while it was still
  being prepared for re-use.  This could lead to a replication error or volumes
  stuck in "syncing" state.
- No longer logs an error when deleting a volume with no data.

## 1.0.0-rc4 - Released 18/07/2018

Multiple bug fixes and improvements, and improved shutdown handling.

### New

- Available capacity is now used in volume placement decisions.  This should
  allow for a more even distribution of capacity across the cluster, especially
  in clusters with large volumes.
- Licenses can now be applied from the Web UI.


### Improved

- The shutdown process has been improved within the data plane, speeding up
  the removal of devices and reducing the risk that the container runtime or
  orchestrator will forcefully stop StorageOS.
- IO operations on volumes being deleted now return a fatal error so that the
  operation is not retried and can fail immediately.
- During node filtering for volume scheduling decisions, it was possible to
  return duplicate nodes as candidates for the volume placement.  This resulted
  in slightly unbalanced placement across the cluster.
- Volume replica removal didn't prioritise syncing volumes over healthy.  This
  meant that a fully-synced replica might be removed instead of one that is not
  yet synced, in cases where the number of replicas was increased and then
  immediately reduced.
- Log verbosity has been reduced at info level.  Set `LOG_LEVEL=debug` for more
  verbose logging.

### Fixed

- UI labels overlapped when window resized in Firefox.
- You can now provision the licenced amount, rather than up to the licenced
  amount fixing: "cannot provision volume with size 999 GB, currently
  provisioned: 1 GB, licenced: 1000 GB".


## 1.0.0-rc3 - Released 02/07/2018

Multiple improvements based on customer feedback.

### New

- StorageOS can now be installed alongside other storage products that make use
  of the Linux SCSI Target driver.
- The CLI now checks for version compatibility with the API.


### Improved

- Volume deletion now uses the scheduler's desired state processing rather than
  the previous imperative operation.  This fixes an issue where deletes could be
  stuck in pending state if the scheduler loses state (e.g. from a restart)
  while the operation is in progress.  Now the operation is idempotent and will
  be retried until successful.
- Volume placement now distributes volumes across nodes more evenly.
- CSI version 0.3 (latest) is now fully supported.  Additionally, improvements
  to CSI include how the default filesystem is determined, read-only mounts, and
  better checking for volume capabilities.
- Internal communication now times out after 5 seconds instead of 60.  This
  allows retry or recovery steps to initiate much quicker than before.  This
  timeout only affects inter-process communication on the same host, not over
  the network to remote hosts.
- Added a "degraded" state to the internal health monitoring.  This allows a
  recovery period before marking a node offline, which then triggers a restart.
  This improves stability when the KV store (internal or external) is undergoing
  a leadership change.
- Minor improvements to the UI notifications and error messages.
- Upgraded controlplane compiler to Golang 10.0.3 (from 1.9.1).

### Fixed

- Online device resizing now works with SCSI devices.  Note that `resize2fs`
  still needs to be run manually on the filesystem, and we are working on making
  this step automated.
- When deleting data from a volume, some metadata was not always being removed.
  This meant that volumes with frequently changing data could use more capacity
  than allocated.


## 1.0.0-rc2 - Released 31/05/2018

Single fix to address provisioning issue in Amazon AWS.

### Fixed

- Increased time to wait for device to appear, causing volume creation to fail.
  This was encountered on Xen-based RHEL/Centos VMs running in Amazon AWS.

## 1.0.0-rc1 - Released 25/05/2018

The 1.0 release series is focussed on supporting enterprise workloads, with
numerous new features and improvements to performance, stability and
maintainability.

### Breaking changes

- Several internal data structures were changed and are not compatible with
  previous versions.  For this reason upgrades from version 0.10.x and earlier
  are not supported.
- The API endpoint `/v1/metrics` has been replaced with `/metrics` to conform
  with Prometheus best practices.

### New

- Volume presentation has changed to use the SCSI subsystem via the
  Linux SCSI Target driver. Previous versions used NBD where available, or FUSE
  where it wasn't.  Using the new volume presentation improves performance on
  the RHEL platform where NBD is not available.  This feature is available for
  all major distributions and is widely used.  For more information, see
  [system configuration]({%link _docs/prerequisites/systemconfiguration.md %})
- Internally, the StorageOS scheduler has switched to using level-based state
  handling and the gRPC protocol.  This allows the scheduler to make assertions
  about the current state, rather than relying on events that can be missed.
  The scheduler now behaves in the same way as Kubernetes controllers do; by
  evaluating the current state, calculating adjustments, sharing desired state
  and allowing individual components to apply differences.  For more information
  on level triggered logic, see
  [Edge vs Level triggerd logic](https://speakerdeck.com/thockin/edge-vs-level-triggered-logic)
- Encyption at-rest is available on a per-volume level by setting the label
  `storageos.com/encryption=true`.  In Kubernetes, volume encryption keys are
  stored in Secrets.  Elsewhere, keys are stored in etcd, the key-value store
  used internally within StorageOS.  No other configuration is required.
- Container Storage Interface (CSI) version 0.2 compatibility.  CSI is a
  specification for storage providers that enables StorageOS to support any
  orchestrator that supports CSI.  Currently this includes Kubernetes and
  derivatives, Mesos and Docker.  Over time CSI will replace the native driver
  in Kubernetes, though the existing v1 API will remain.
- Multiple devices on a node can now be used, and StorageOS will shard data
  across them.
- Node maintenance command such as `storageos node cordon` and `storageos node
  drain` aid upgrades by live-migrating active volumes prior to node maintenance.
- Node labels can now be used for volume anti-affinity, allowing StorageOS to
  make sure a master volume and its replicas are in separate failure domains.
- Cloud provider failure domains are now auto-set as labels for nodes deployed
  in Azure, AWS or GCE.
- Administrators can download or upload to Storageos, support, cluster
  information and log files.  This is currently only available via the Web
  interfce or the API.
- Kubernetes mount option support (requires Kubernetes 1.10).

### Improved

- Performance has improved significantly throughout and has been thoroughly
  tested on a variety of workloads.  Specific areas include optimisations for
  larger block sizes and improvements to the caching engine.
- Volumes will go read-only shortly before the underlying device runs out of
  space.  This allows the filesystem to handle errors gracefully and can protect
  against corruption.
- Pools have been overhauled to be dynamic, making use of label selectors.
- Increased number of volumes per node.
- Invalid labels now generate a validation error.
- `storageos.com/` namespaced labels must validate against known labels.

### Fixed

- Mapping of compression and throttle labels.
- Remove hard connection limit on replication services.
- `docker ps` shows unhealthy when everything is fine.
- Throttle impact was too small to be noticed.
- Volume size '0' produced 10GB volume.
- Re-adding user to a group creates a duplicate entry.
- Node and pool capacity stats were sometimes wrong.

# Previous Releases

## Upgrades

Due to breaking changes between 0.9.x and 0.10.x upgrading is not possible.
Instead we recommend that you provision a new cluster and migrate data.

Please update to the latest CLI when installing 0.10.x.

### 0.8.x -> 0.9.x

Start-up scripts should be updated to use the new cluster discovery syntax (See:
https://docs.storageos.com/docs/install/prerequisites/clusterdiscovery)

Do not mix a cluster with 0.8.x and 0.9.x versions as port numbers have changed.
This may cause cluster instability while nodes are being upgraded.

### 0.7.x -> 0.8.x

Due to the nature the KV Store change there is no upgrade method from 0.7.x to
0.8.x+.  Our recommendation is to create a new cluster, paying attention to the
new parameters (`CLUSTER_ID` and `INITIAL_CLUSTER`).  Note that `CLUSTER_ID` and
`INITIAL_CLUSTER` have been replaced by `JOIN` in 0.9.x onwards.

## 0.10.0 - Released 28/02/2018

The 0.10.0 version focusses on stability and usability as we get closer to GA,
but also adds a number of new features (UI, Prometheus metrics, log streaming).

### Breaking changes

We took the decision to bundle as many known breaking changes into this release
in order to reduce pain later.

- The API endpoint `/v1/controllers` has been replaced with `/v1/nodes`.  This
  removes the concept of storage controllers being different objects from
  storage clients.  Now both are simply nodes, with the
  `storageos.com/deployment` label used to configure the deployment type.
  Deployment types can be `computeonly` and `mixed` are supported, with `mixed`
  being the default.

  Older versions of the CLI should be mostly backwards compatible but some
  features such as node and pool capacity will not work.

- The label format for configuring StorageOS features has changed from
  `storageos.feature.xyz` to `storageos.com/xyz`.  This format is more familiar
  to Kubernetes users.  Using the old format will still work until 0.11 when
  conversion will be removed.  In 0.10 a deprecation notice will be issued.

- The environment variable used to add labels to nodes at startup time has
  changed from `LABEL_ADD` to `LABELS`.  Multiple labels can be comma-separated:
  `LABELS=storageos.com/deployment=computeonly,region=us-west-1`

### New

- There is now a Web interface, available on all cluster nodes on the API port
  (`5705`).  To access, point your web browser to http://ADVERTISE_IP:5705.
  where ADVERTISE_IP is the public ip address of a StorageOS node.  Unless you
  have changed the default credentials, login with user `storageos`, password
  `storageos`.  See: {% link _docs/reference/gui.md %}
- Prometheus stats are exported on each cluster node at
  http://ADVERTISE_IP:5705/v1/metrics.  Prometheus 2.x is required.
- The CLI can now stream realtime logs from the active StorageOS cluster with
  `storageos logs -f`.  Logs are aggregated from all cluster nodes over a single
  connection to the API.  Future releases will add support for filtering and
  controlling the log level.  See: {% link _docs/reference/cli/logs.md %}
- The location of the StorageOS volumes can now be configured on a per-node
  basis by setting the `DEVICE_DIR` environment variable on the StorageOS node
  container.

  This is especially useful when running Kubernetes in a container
  and you are unable or unwilling to share the default `/var/lib/storageos/volumes`
  location into the `kubelet` container.  Instead, share the `kubelet` plugin
  directory into the StorageOS container, and set `DEVICE_DIR` to use it.
  Hovever, Kubernetes 1.10 will be required in order for `kubelet` to use a
  directory other than `/var/lib/storageos/volumes`.

  For example:

  ```bash
  JOIN=$(storageos cluster create)
  docker run --rm --name storageos \
    -e HOSTNAME \
    -e DEVICE_DIR=/var/lib/kubelet/plugins/kubernetes.io~storageos/devices \
    -e JOIN=${JOIN} \
    --pid host \
    --privileged --cap-add SYS_ADMIN \
    -v /var/lib/kubelet/plugins/kubernetes.io~storageos:/var/lib/kubelet/plugins/kubernetes.io~storageos:rshared \
    --device /dev/fuse \
    --net host \
    storageos server
   ```

### Improved

- `soft` volume failure mode will now tolerate the replica being offline (for
  example during a node reboot), if there is only one replica configured.  To
  ensure there are always two copies of the data, use `hard` mode with a single
  replica, or use two replicas with `soft` mode.
- Ensure volumes can only be mounted with the correct underlying filesystem.
  You will now get a validation error if you try to mount an ext3 formatted
  filesystem as ext4.  `ext4` is the default if not specified when mounting an
  unformatted volume.

### Fixed

- Ensure cache is invalidated after mkfs.  Fixes mount error 32 that could occur
  with Kubernetes or OpenShift on Centos/RHEL.
- Memory leak in replication client led to excessive use over time.
- Standardised all paths to 256 byte length to support user-configurable
  `DEVICE_DIR`.
- Fixed clean shutdown issue where filesystem could start new threads while
  shutting down.  This was only observed in stress tests.
- Shutdown signal handling improved, fixing `Transport endpoint is not connected`
  on Centos / RHEL in certain restart situations.

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

  These actions are used primarily for automated testing where we introduce
  instability into the cluster to ensure there is no service disruption.

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

## 0.9.0 - Released 17/11/2017

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
  [NBD kernel module]({%link _docs/prerequisites/systemconfiguration.md %})
  on those platforms.

## 0.8.1

### Improved

- NBD device numbers now start at 1 instead of 0 to defend against default values

## 0.8.0 - Released 29/08/2017

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
  [NBD kernel module]({%link _docs/prerequisites/systemconfiguration.md %})
  on those platforms.

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
