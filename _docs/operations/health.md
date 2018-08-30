---
layout: guide
title: StorageOS Docs - Health
anchor: operations
module: operations/health
---

# Cluster health

Various tools are available for checking on the status of a cluster.

The [StorageOS CLI]({%link _docs/reference/cli/index.md %}) displays the status
of the components on nodes in the cluster.

```bash
$ storageos cluster health
NODE         ADDRESS         CP_STATUS  DP_STATUS
storageos-1  192.168.50.100  Healthy    Healthy
storageos-2  192.168.50.101  Healthy    Healthy
storageos-3  192.168.50.102  Healthy    Healthy
```

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
{"submodules":{"kv":{"status":"alive","message":"","updatedAt":"2017-08-16T14:24:59.898288145Z","changedAt":"2017-08-16T13:06:18.672362683Z"},"kv_write":{"status":"alive","message":"","updatedAt":"2017-08-16T14:24:59.898289093Z","changedAt":"2017-08-16T13:06:27.475859537Z"},"nats":{"status":"alive","message":"","updatedAt":"2017-08-16T14:24:59.898287588Z","changedAt":"2017-08-16T13:06:27.475858077Z"},"scheduler":{"status":"alive","message":"","updatedAt":"2017-08-16T14:24:59.898288556Z","changedAt":"2017-08-16T13:06:27.475859095Z"}}}
```
