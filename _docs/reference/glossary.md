---
layout: guide
title: Glossary of terms
anchor: reference
module: reference/glossary
---

# Glossary of terms


| StorageOS term        | Meaning                                      |
|:----------------------|:---------------------------------------------|
| Cluster               |Refers to what was traditionally described as an array with the key difference that an array comprises disks whereas a cluster comprises nodes|
| ConfigFS              |An interpreted configuration representing desired state|
| StorageOS Container   |StorageOS instance with run-time parameters defining components and role|
| Control Plane         |StorageOS component responsible for managing configuration, rules engine, provisioning and recovery processes|
| Data Plane            |StorageOS component that processes all data access requests and pools the aggregated storage for presentation to clients|
| Dedupe                |Abbreviated term for deduplicate or deduplication (see also https://en.oxforddictionaries.com/definition/dupe and http://www.dictionary.com/browse/dedupe)|
| Docker Plugin         |The Docker managed plugin install method requires Docker 1.13+ or above - installs Data Plane and Control Plane in the same container|
| StorageOS Container   |StorageOS container package. Specifying image is optional.|
| Key/Value Store or KV Store|Key/Value store used for service discovery, configuration and health checking|
| Container Install     |Container-based installation method pre Docker 1.13|
| StorageOS Node        |A unit within a cluster typically running the StorageOS Control Plane and Data Plane software responsible for aggregating and serving out storage to clients|
| Node Discovery        |Serf is used for decentralised node discovery to detect and notify node failures to the remaining cluster nodes using Gossip|
| REST                  |Representational State Transfer (sometimes referred to as ReST) is a means of providing interoperability between computer systems on the Internet.  RESTful is typically used to refer to web services implementing such an architecture|
| UUID                  |Universally Unique Identifier is a 128-bit number used to identify information in computer systems which for practical purposes are unique|
| Unix/unix             |Trademarked as UNIX, is a family of multitasking, multiuser computer operating systems that derive from the original AT&T Unix, developed starting in the 1970s at the Bell Labs research center|
| No-Knowledge Encryption|A means of ensuring hosting service providers know nothing about the data stored on their servers (see also https://tresorit.com/blog/zero-knowledge-encryption/)|
