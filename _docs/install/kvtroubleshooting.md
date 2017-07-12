---
layout: guide
title: StorageOS Docs - KV Store Troubleshooting
anchor: install
module: install/kvtroubleshooting
---

# KV Store Troubleshooting

A healthy KV Store is essential for StorageOS operation.  The KV Store must be
accessible to start StorageOS and to make any provisioning changes.  Once a
StorageOS cluster is running data presentation services will continue to operate
if the KV Store becomes unavailable though no changes can be made until it has
recovered.

## Consul External KV Store
This section assumes that Consul has been installed by following the
[Consul installation]({% link _docs/install/kvstore.md %}) guide.

Depending on your installation, Consul may be running on the same node as
StorageOS or on remote nodes.  Find the correct server by looking at the ip
address specified in the `KV_ADDR` setting passed to the StorageOS container.

### Verify Consul is accessible at KV_ADDR

On any StorageOS node having difficulties (or just to verify), try to connect to
the Consul cluster using the address details given to StorageOS in the KV_ADDR
setting.

By default, this is `127.0.0.1:8500`, and assumes that Consul is running
locally.

```bash
$ curl 127.0.0.1:8500/v1/status/peers
["172.28.128.3:8300","172.28.128.9:8300","172.28.128.15:8300"]
```

A successful response will list the cluster members as above.

Possible errors:

- `curl: (7) Failed to connect to 127.0.0.1 port 8500: Connection refused`

  Consul is not accessible locally.  First, check the consul container (see
  "Check Consul container" below).

  If the container is running, check to make sure it is listening on 127.0.0.1
  (see check listen address below) .

### Check Consul container

Depending on your installation, Consul may be running on the same node as
StorageOS or on remote nodes.  Find the correct server by looking at the ip
address specified in the `KV_ADDR` setting passed to the StorageOS container.

On the host meant to be running Consul, check whether container is running:

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
215c7b017c54        consul              "docker-entrypoint..."   3 weeks ago         Up 2 weeks                              consul
```

### Check Consul Listen Address

By default, Consul should be listening on all network interfaces.

It must be accessible on a public address so that it may receive events from
other cluster members and from remote StorageOS nodes.

When following our documentation, we also suggest running Consul on the first 3
StorageOS nodes and accessisng it using the localhost address, mainly for
simplicity.

To check Consul is listening correctly:

```bash
# netstat -an | grep LISTEN | grep :8500
tcp6       0      0 :::8500                 :::*                    LISTEN
```

If the 4th column is not `:::0` or `*.8500` (for ipv4-only hosts), then check
the Consul container configuration, paying special attention to the `-client`
parameter, which should be set to `0.0.0.0` so that the Consul API will listen
on all addresses.  The `-bind` parameter should be set to the primary public ip
address of the node if there are multiple non-local addresses.

The Consul container must also be running with host networking enabled, by
specifying `--net=host` on the `docker run` command.

### Verify Consul health

Consul requires [quorum](https://www.consul.io/docs/internals/consensus.html) in
order to accept write requests.  Quorum is achieved by having the majority of
cluster members actively connected to the cluster and reporting that they are
healthy.  Each member votes to elect a single leader, which will then be
responsible for accepting writes and replicating to followers.

To verify cluster quorum health:

```bash
$ curl 127.0.0.1:8500/v1/status/leader
"172.28.128.3:8300"
```

If an empty string is returned, the cluster is un-healthy and further
investigation is required.

For more detail:

```bash
$ docker exec -it consul consul operator raft -list-peers
Node               ID                  Address             State     Voter
storageos-1-38631  172.28.128.3:8300   172.28.128.3:8300   follower  true
storageos-2-38631  172.28.128.9:8300   172.28.128.9:8300   leader    true
storageos-3-38631  172.28.128.15:8300  172.28.128.15:8300  follower  true
```

There should be at least one leader displayed.

To troubleshoot leadership election issues, the following commands are useful:

- `docker logs consul`

  Run this on each node to try to determine which node may be failing to join
  the cluster.

- `docker ps`

  To verify container is running correctly.

- `docker inspect consul`

  To view running configuration.

## StorageOS Configuration

Once you are able to confirm that the KV Store is healthy and listening on the
correct ip address and port, you should verify that StorageOS is connected to
it.

### Verify Storage Connection to KV Store

Use StorageOS' health endpoint to check status:

```bash
$ curl -s http://127.0.0.1:5705/v1/health | jq
{
  "submodules": {
    "kv": {
      "status": "alive",
      "updatedAt": "2017-07-07T13:25:57.352676882Z",
      "changedAt": "0001-01-01T00:00:00Z"
    },
    "kv_write": {
      "status": "alive",
      "updatedAt": "2017-07-07T13:25:57.352677371Z",
      "changedAt": "0001-01-01T00:00:00Z"
    },
    "nats": {
      "status": "alive",
      "updatedAt": "2017-07-07T13:25:57.3447165Z",
      "changedAt": "0001-01-01T00:00:00Z"
    },
    "scheduler": {
      "status": "alive",
      "updatedAt": "2017-07-07T13:25:57.344992396Z",
      "changedAt": "0001-01-01T00:00:00Z"
    }
  }
}
```

The `kv` submodule should report `alive`.

### Verify StorageOS KV_ADDR Configuration

```bash
$ docker logs storageos 2>&1 | grep "kv address"
    external kv address: 127.0.0.1:8500
```

Depending on your installation, the primary public ip may also be used:

```bash
$ docker logs storageos 2>&1 | grep "kv address"
    external kv address: 172.28.128.3:8500
```

To verify the connection succeeded:

```bash
$ docker logs storageos 2>&1 | grep "connected"
time="2017-07-07T13:46:48Z" level=info msg="connected to kv store"
time="2017-07-07T13:46:48Z" level=info msg="connected to kv store"
time="2017-07-07T13:46:48Z" level=info msg="connected to store" address="127.0.0.1:8500" backend=consul
```

If there are errors, investigate the following:

- `KV_ADDR` is set correctly.
- `docker logs storageos` does not show anything unusual.

If you are unsure, [ask for help]({% link _docs/reference/get_help.md %}).
