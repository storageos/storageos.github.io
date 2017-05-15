---
layout: guide
title: StorageOS Docs - Release notes
anchor: reference
module: reference/release_notes
---

# Beta warning

StorageOS is currently in Beta. This allows users to explore our software prior to General Availability (GA) release. Any feedback on software problems and usability will help improve our product and allows us to track issues and fix them.

As public Beta software, StorageOS has yet to be released commercially and may contain imperfections causing the software not to perform as well as GA release software. _We therefore recommend you only install this on non-production, non-business critical infrastructure or devices._

Before the GA release, data formats used by StorageOS may change and there may not be an automated migration process. When upgrades break compatibility or require manual migration processes we will endeavour to make this clear in the release notes.

We recommend always using "tagged" versions of StorageOS rather than "latest", and to perform upgrades only after reading the release notes.

## Known Issues

- `storageos volume mount <vol> <mountpoint>` sometimes hangs on Managed Plugin installs.  Volumes mount into containers correctly using Docker.
- Docker can only access volumes created in the `default` namespace.

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
- Do not mark a recovered controller available immediately, wait to detect flapping
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
