---
layout: guide
title: StorageOS Docs - Release notes
anchor: reference
module: reference/release_notes
---

# Release Notes

We recommend always using "tagged" versions of StorageOS rather than "latest",
and to perform upgrades only after reading the release notes.

The latest tagged release is `{{ site.latest_node_version }}`, available from the
[Docker Hub](https://hub.docker.com/r/storageos/node/) as
`storageos/node:{{ site.latest_node_version }}`, or via the
[Helm Chart](https://github.com/storageos/helm-chart)

The latest CLI release is `{{ site.latest_cli_version }}`, available from
[Github](https://github.com/storageos/go-cli/releases)

## Upgrades

Upgrades can be performed by restarting the StorageOS node container with the
new version.

Before a node is upgraded, applications local to the node that mount StorageOS
volumes should be migrated to other cluster nodes or their data volumes will be
unavailable while the StorageOS container restarts.

See [Node maintenance]({%link _docs/concepts/maintenance.md %}) for commands to help
with online migration of volumes.

The [StorageOS CLI](https://github.com/storageos/go-cli) should normally be
updated when upgrading the cluster version.

Where there are special considerations they are described below.

### 0.10.x - 1.0.x

Due to breaking changes between 0.10.x and 1.0.x upgrading is not possible.  We
will now endeavour to allow upgrades between versions.

If you are installing on a node that has had a previous version installed, make
sure that the contents of `/var/lib/storageos` has been removed, and that you
provision with a new cluster discovery token (if using).

## 1.0.0-rc5

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
- TODO: network connectivity
- TODO: licence placeholder: DEV-1224
- TODO: Metrics placeholder, DEV-2243, DEV-2536


### Improved

- Increased performance by reducing context switches in the IO path when passing
  data to or from the backend. (TODO: give rough % increase?)
- Increased replication performance by optimising the parallel writes to
  multiple destinations.  With >1 replicas this will roughly double replication
  performance, but it also reduces the overhead of adding additional replicas to
  a volume.
- Time taken to detect and recover from a node failure reduced from 45-70
  seconds to <15 seconds.
- Replaced the internal distributed lock mechanism to ensure correct and
  deterministic behaviour in the majority of failure scenarios.  Nodes are now
  notified when locks are released and acquired, and there is a consistent view
  of which node holds the lock.
- Implemented basic check-and-set (CAS) on control plane operations where
  consistency is required.
- Stop all control plane state evaluations if KV store is unavailable for more
  than the distributed lock TTL (5 seconds).
- Ensure node does not participate in state evaluations when it has been set as
  unschedulable with `storageos node cordon` or `storageos node drain`.
- Internal library change from [Serf](https://github.com/hashicorp/serf) to
  [Memberlist](https://github.com/hashicorp/memberlist).  This helped simplify
  node failure detection.
- Control plane state evaluations are now performed serially with an interval of
  once per second.  This reduces the load on the cluster during bulk or recovery
  operations.  Previously, multiple workers may try to apply the same changes,
  causing unnessessary validation to take place.  A Prometheus histogram has
  been added to track duration of each state evaluation.  Under normal operation
  it takes 10-50ms.
- Node capacity now includes capacity from all devices made available for use by
  StorageOS.
- Volume health improved.  Health is now defined as:

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

- Migrate from vue-resource to Axios for handling ajax requests in the Web UI.
- Warnings are now logged when volumes can not be provisioned due to licensing
  constraints.
- Internal logging improvements to ensure that runtime changes to log levels or
  filters maintain consistency across multiple consumers.
- Diagnostic requests now support JSON requests via the "Accepts" header,
  defaulting to the current tar archive response.  Internally, collection from
  multiple nodes is now streamed with a timeout of 10 seconds to prevent a
  deadlocked node from blocking the response.
- Improved description and flow of cluster diagnostics upload.
- Web UI volume detail page re-designed.
- Web UI theme tweaks: list view, pagination, headers, in-place edit.
- Upgrade internal messaging library and restructure implementation.
- Ensure the API supports label selectors on all object listings and improve
  internal code consistency and tests.
- Ensure control plane workers and gRPC connection pool are shutdown cleanly
  prior to shutting down the data plane to ensure operations have completed and
  to reduce warnings in logs.
- Explicitly shutdown the data plane gRPC handlers in the replication client
  prior to shutting down the rest of the data plane.  This protects against a
  potential issue that could lead to unclean shutdown.
- The lun ID was previously set to use the device ID for convenience.  This has
  now been decoupled in order to support devices across multiple HBAs in the
  future, which will remove the limitation of 256 volumes on RHEL/Centos
  clusters.
- Bulk volume creation could cause excessive validation warning messages in the
  logs do to concurrent configuration requests to the data plane.  Now, if the
  volume already exists or a CAS update fails, a conflict error (rather than
  generic error) is returned to the control plane.  This allows the control
  plane to only log a warning or error message if the intended action failed.
- Ongoing log message readability and tuning of log levels.

### Fixed

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
  the client's server pair could be cleared while IO was still in progress.  A
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
- Filesystems now behave correctly when the underlying data store is out of
  capacity.  Previously the filesystem would appear to hang as it would retry
  the operation indefinitely.  Now, the filesystem will receive a fatal error
  and will typically make itself read-only.
- Remove race condition in internal blob metadata creation, never seen to cause
  an issue.
- No longer logs an error when deleting a volume with no data.

## 1.0.0-rc4

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


## 1.0.0-rc3

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


## 1.0.0-rc2

Single fix to address provisioning issue in Amazon AWS.

### Fixed

- Increased time to wait for device to appear, causing volume creation to fail.
  This was encountered on Xen-based RHEL/Centos VMs running in Amazon AWS.

## 1.0.0-rc1

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

## 0.10.0

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
  [NBD kernel module]({%link _docs/prerequisites/systemconfiguration.md %})
  on those platforms.

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
