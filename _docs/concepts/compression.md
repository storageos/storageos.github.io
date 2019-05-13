---
layout: guide
title: StorageOS Docs - Compression
anchor: concepts
module: concepts/compression
---

# Compression

StorageOS compression is handled on a per volume basis and is enabled by
default, as performance is generally increased when compression is enabled due
to fewer read/write operations taking place on the backend store (the volumes'
[blob files](/docs/concepts/volumes#blob-files)). Compression can be disabled
by setting the [label](/docs/reference/labels) `storageos.com/nocompress=true`
on a volume.

StorageOS utilises the [lz4 compression algorithm](https://lz4.github.io/lz4/)
when writing to the backend store and when compressing [replication
traffic](/docs/concepts/replication) before it is sent across the network.
Compression is granular per 4k block and data will remain
compressed/uncompressed once written to a volume. Therefore, compression can be
dynamically enabled and disabled by setting the `storageos.com/nocompress`
label on a volume.

StorageOS detects whether a block can be compressed or not by creating a
heuristic that predicts the size of a compressed block. If the heuristic
indicates that the compressed block is likely to be larger than the
original block then the uncompressed block is stored. Block size increases post
compression if the compression dictionary is added to a block that cannot be
compressed. By verifying whether blocks can be compressed, disk efficiency is
increased and CPU resources are not wasted on attempts to compress
uncompressible blocks. StorageOS' patented on disk format is used to tell
whether individual blocks are compressed without overhead. As such volume
compression can be dynamically enabled/disabled even while a volume is in use.

When compression and [encryption](/docs/concepts/encryption) are both enabled
for a volume, blocks are compressed then encrypted.


