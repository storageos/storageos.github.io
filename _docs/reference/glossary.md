---
layout: guide
title: StorageOS Docs - Glossary
anchor: reference
module: reference/glossary
---

# Glossary of terms

| StorageOS term        | Meaning                                      |
|:----------------------|:---------------------------------------------|
| ConfigFS              |An interpreted configuration representing desired state|
| Control Plane         |StorageOS component responsible for managing configuration, rules engine, provisioning and recovery processes|
| Data Plane            |StorageOS component that processes all data access requests and pools the aggregated storage for presentation to clients|
| Dedupe                |Abbreviated term for deduplicate or deduplication|
| Docker Plugin         |The Docker managed plugin install method for Docker 1.13+|
| Key/Value Store or KV Store|Key/Value store used for service discovery, configuration and health checking|
| Container Install     |Container-based installation method pre Docker 1.13|
| StorageOS Node        |A unit within a cluster running the StorageOS software responsible for aggregating and serving out storage to clients|
| Node Discovery        |Serf is used for decentralised node discovery to detect and notify node failures to the remaining cluster nodes using Gossip|
| REST                  |Representational State Transfer (sometimes referred to as ReST) is a means of providing interoperability between computer systems on the Internet.  RESTful is typically used to refer to web services implementing such an architecture|
| StorageOS Container   |StorageOS instance running the control plane and data plane|
| StorageOS cluster     |A cluster with StorageOS-managed storage, via installing the software on each node|
| UUID                  |Universally Unique Identifier is a 128-bit number used to identify information in computer systems which for practical purposes are unique|
