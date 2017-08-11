---
layout: guide
title: StorageOS Docs - Health
anchor: install
module: install/health
---

# Cluster health

Various tools are available for checking on the status of a cluster.

### Cluster members

The [StorageOS CLI]({%link _docs/reference/cli/index.md %}) displays the status of the nodes in the cluster.

```bash
$ storageos node ls
NAME                ADDRESS             HEALTH               SCHEDULER           VOLUMES             TOTAL               USED                VERSION                 LABELS
storageos-1         192.168.50.100      Healthy 37 minutes   true                M: 1, R: 0          37.79 GiB           4.65%               22c3cf0 (22c3cf0 rev)
storageos-2         192.168.50.101      Healthy 37 minutes   false               M: 0, R: 0          37.79 GiB           4.62%               22c3cf0 (22c3cf0 rev)
storageos-3         192.168.50.102      Healthy 35 minutes   false               M: 0, R: 0          37.79 GiB           4.62%               22c3cf0 (22c3cf0 rev)
```

### API services

The API server reports its status at the `/v1/health` endpoint.

```bash
$ curl -v http://localhost:5705/v1/health
*   Trying ::1...
* Connected to localhost (::1) port 5705 (#0)
> GET /v1/health HTTP/1.1
> Host: localhost:5705
> User-Agent: curl/7.47.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Access-Control-Allow-Headers: Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization
< Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE
< Access-Control-Allow-Origin: *
< Content-Type: application/json
< Date: Fri, 11 Aug 2017 12:07:55 GMT
< Content-Length: 539
<
* Connection 0 to host localhost left intact
{"submodules":{"kv":{"status":"alive","message":"","updatedAt":"2017-08-11T12:07:55.503707066Z","changedAt":"2017-08-11T11:31:41.124110346Z"},"kv_write":{"status":"alive","message":"","updatedAt":"2017-08-11T12:07:55.503707825Z","changedAt":"2017-08-11T11:31:51.088848317Z"},"nats":{"status":"alive","message":"","updatedAt":"2017-08-11T12:07:55.503706574Z","changedAt":"2017-08-11T11:31:51.088844662Z"},"scheduler":{"status":"alive","message":"","updatedAt":"2017-08-11T12:07:55.503707417Z","changedAt":"2017-08-11T11:31:51.088847582Z"}}}
```

### Installation

For container installs (`storageos/node`), pipe the container logs to grep to check that the cluster services initialized correctly:

```bash
$ docker ps
CONTAINER ID        IMAGE                          COMMAND              CREATED             STATUS                    PORTS               NAMES
f01c6551b5eb        storageos/node:latest   "storageos server"   35 minutes ago      Up 35 minutes (healthy)                       storageos
$ docker logs f01c6551b5eb  2>/dev/null | grep StorageOS
By using this product, you are agreeing to the terms of the StorageOS Ltd. End User Subscription Agreement (EUSA) found at: https://storageos.com/legal/#eusa
==> Starting StorageOS server...
    version: StorageOS 22c3cf0, Built: 2017-08-10T141824Z
==> StorageOS server running!
```
