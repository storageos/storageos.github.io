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
{"submodules":{"kv":{"status":"alive","message":"","updatedAt":"2017-08-11T12:07:55.503707066Z","changedAt":"2017-08-11T11:31:41.124110346Z"},"kv_write":{"status":"alive","message":"","updatedAt":"2017-08-11T12:07:55.503707825Z","changedAt":"2017-08-11T11:31:51.088848317Z"},"nats":{"status":"alive","message":","updatedAt":"2017-08-11T12:07:55.503706574Z","changedAt":"2017-08-11T11:31:51.088844662Z"},"scheduler":{"status":"alive","message":"","updatedAt":"2017-08-11T12:07:55.503707417Z","changedAt":"2017-08-11T11:31:51.088847582Z"}}}
```

### Install logs

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

For plugin installs (`storageos/plugin`), use `journalctl` to view logs:
```bash
$ journalctl | grep StorageOS
Aug 11 15:27:06 storageos-1 dockerd[14521]: time="2017-08-11T15:27:06Z" level=info msg="By using this product, you are agreeing to the terms of the StorageOS Ltd. End User Subscription Agreement (EUSA) found at: https://storageos.com/legal/#eusa" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:06 storageos-1 dockerd[14521]: time="2017-08-11T15:27:06Z" level=info msg="==> Starting StorageOS server..." plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:12 storageos-1 dockerd[14521]: time="2017-08-11T15:27:12Z" level=info msg="    version: StorageOS c456268, Built: 2017-08-10T105011Z" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:15 storageos-1 dockerd[14521]: time="2017-08-11T15:27:15Z" level=info msg="==> StorageOS server running!" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:15 storageos-1 dockerd[14521]: time="2017-08-11T15:27:15Z" level=info msg="StorageOS Volume Presentation level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:15 storageos-1 dockerd[14521]: time="2017-08-11T15:27:15Z" level=info msg="StorageOS DirectFS v1 server (server v0.1 protocol v1.2) start level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:16 storageos-1 dockerd[14521]: time="2017-08-11T15:27:16Z" level=info msg="StorageOS DIRECTOR category=director level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:16 storageos-1 dockerd[14521]: time="2017-08-11T15:27:16Z" level=info msg="StorageOS DirectFS v1 client (server v0.1 protocol v1.2) start category=clinit level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:17 storageos-1 dockerd[14521]: time="2017-08-11T15:27:17Z" level=info msg="StorageOS RDB plugin category=rdbplginit level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
```
