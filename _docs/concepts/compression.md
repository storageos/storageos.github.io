---
layout: guide
title: StorageOS Docs - Compression
anchor: concepts
module: concepts/compression
---

# Compression

StorageOS compression is handled on a per volume basis and is enabled by
default. Compression is enabled by default, as performance is generally
increased when compression is enabled due to fewer read/write operations
needing to take place on the backend store. Compression can be disabled by
setting the label `storageos.com/nocompress=true` on a volume. 

StorageOS utilises the [lz4 compression algorithm](https://lz4.github.io/lz4/)
when writing to the backend store (the volumes' [blob
files](/docs/concepts/volumes#blob-files)) and when compressing [replication
traffic](/docs/concepts/replication) before it is sent across the network.
Compression is granular per 4k block and data will remain
compressed/uncompressed once written to a volume. Therefore, an individual
volume can store both compressed data blocks and uncompressed data blocks at
the same time. As such volume compression can be dynamically enabled/disabled.

StorageOS can detect whether a block can be compressed or not. If a single
block is uncompressible it is written as is, therefore there is no overhead in
writing compressed files to a volume. For example archive files will not be
compressed when written to compressed volumes.

When compression and [encryption](/docs/concepts/encryption) are both enabled
for a volume, blocks are compressed then encrypted.
