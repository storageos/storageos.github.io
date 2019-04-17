---
layout: guide
title: StorageOS Docs - API
anchor: reference
module: reference/cli/cluster
---

# Cluster

```bash
$ storageos cluster

Usage:	storageos cluster COMMAND

Manage clusters

Aliases:
  cluster, c

Options:
      --help   Print usage

Commands:
  connectivity Display connectivity diagnostics for the cluster
  create       Creates a cluster initialization token.
  health       Displays the cluster's health.
  inspect      Display detailed information on one or more cluster
  maintenance  Enable|disable maintenance mode for the cluster
  rm           Remove one or more clusters

Run 'storageos cluster COMMAND --help' for more information on a command.
```
### `storageos cluster connectivity`
To check the connectivity of the cluster
```bash
$ storageos cluster connectivity
SOURCE                NAME                           ADDRESS           LATENCY     STATUS  MESSAGE
storageos-nodes2  storageos-nodes1.api       10.0.12.154:5705  1.085151ms  OK      
storageos-nodes2  storageos-nodes1.directfs  10.0.12.154:5703  1.09232ms   OK      
storageos-nodes2  storageos-nodes1.etcd      10.0.12.154:5707  1.142334ms  OK      
storageos-nodes2  storageos-nodes1.nats      10.0.12.154:5708  1.172353ms  OK      
storageos-nodes2  storageos-nodes1.serf      10.0.12.154:5711  1.11125ms   OK      
storageos-nodes2  storageos-nodes2.api       10.0.12.148:5705  1.204403ms  OK      
storageos-nodes2  storageos-nodes2.directfs  10.0.12.148:5703  1.134408ms  OK      
storageos-nodes2  storageos-nodes2.etcd      10.0.12.148:5707  1.115885ms  OK      
storageos-nodes2  storageos-nodes2.nats      10.0.12.148:5708  1.201178ms  OK      
storageos-nodes2  storageos-nodes2.serf      10.0.12.148:5711  1.111379ms  OK      
storageos-nodes2  storageos-nodes3.api       10.0.12.253:5705  1.143731ms  OK      
storageos-nodes2  storageos-nodes3.directfs  10.0.12.253:5703  1.149442ms  OK      
storageos-nodes2  storageos-nodes3.etcd      10.0.12.253:5707  1.083065ms  OK      
storageos-nodes2  storageos-nodes3.nats      10.0.12.253:5708  1.090467ms  OK      
storageos-nodes2  storageos-nodes3.serf      10.0.12.253:5711  1.158129ms  OK      
storageos-nodes3  storageos-nodes1.api       10.0.12.154:5705  1.145954ms  OK      
storageos-nodes3  storageos-nodes1.directfs  10.0.12.154:5703  1.114514ms  OK      
storageos-nodes3  storageos-nodes1.etcd      10.0.12.154:5707  1.214016ms  OK      
storageos-nodes3  storageos-nodes1.nats      10.0.12.154:5708  1.093753ms  OK      
storageos-nodes3  storageos-nodes1.serf      10.0.12.154:5711  1.076079ms  OK      
storageos-nodes3  storageos-nodes2.api       10.0.12.148:5705  1.206116ms  OK      
storageos-nodes3  storageos-nodes2.directfs  10.0.12.148:5703  1.077688ms  OK      
storageos-nodes3  storageos-nodes2.etcd      10.0.12.148:5707  1.079419ms  OK      
storageos-nodes3  storageos-nodes2.nats      10.0.12.148:5708  1.090791ms  OK      
storageos-nodes3  storageos-nodes2.serf      10.0.12.148:5711  1.15946ms   OK      
storageos-nodes3  storageos-nodes3.api       10.0.12.253:5705  1.098104ms  OK      
storageos-nodes3  storageos-nodes3.directfs  10.0.12.253:5703  1.154387ms  OK      
storageos-nodes3  storageos-nodes3.etcd      10.0.12.253:5707  1.147184ms  OK      
storageos-nodes3  storageos-nodes3.nats      10.0.12.253:5708  1.168365ms  OK      
storageos-nodes3  storageos-nodes3.serf      10.0.12.253:5711  1.10147ms   OK      
storageos-nodes1  storageos-nodes1.api       10.0.12.154:5705  1.141353ms  OK      
storageos-nodes1  storageos-nodes1.directfs  10.0.12.154:5703  1.10065ms   OK      
storageos-nodes1  storageos-nodes1.etcd      10.0.12.154:5707  1.143535ms  OK      
storageos-nodes1  storageos-nodes1.nats      10.0.12.154:5708  1.142812ms  OK      
storageos-nodes1  storageos-nodes1.serf      10.0.12.154:5711  1.125368ms  OK      
storageos-nodes1  storageos-nodes2.api       10.0.12.148:5705  1.126621ms  OK      
storageos-nodes1  storageos-nodes2.directfs  10.0.12.148:5703  1.114407ms  OK      
storageos-nodes1  storageos-nodes2.etcd      10.0.12.148:5707  1.192261ms  OK      
storageos-nodes1  storageos-nodes2.nats      10.0.12.148:5708  1.075251ms  OK      
storageos-nodes1  storageos-nodes2.serf      10.0.12.148:5711  1.191951ms  OK      
storageos-nodes1  storageos-nodes3.api       10.0.12.253:5705  1.080853ms  OK      
storageos-nodes1  storageos-nodes3.directfs  10.0.12.253:5703  1.084045ms  OK      
storageos-nodes1  storageos-nodes3.etcd      10.0.12.253:5707  1.117382ms  OK      
storageos-nodes1  storageos-nodes3.nats      10.0.12.253:5708  1.15015ms   OK      
storageos-nodes1  storageos-nodes3.serf      10.0.12.253:5711  1.075519ms  OK
```

### `storageos cluster create`

To create a cluster token for [cluster discovery]({%link
_docs/prerequisites/clusterdiscovery.md %}):

```bash
$ storageos cluster create
207f0026-3844-40e0-884b-729d79c124b8
```

### `storageos cluster health`

To view the status of cluster nodes:

```bash
$ storageos cluster health
NODE         ADDRESS         CP_STATUS  DP_STATUS
storageos-1  192.168.50.100  Healthy    Healthy
storageos-2  192.168.50.101  Healthy    Healthy
storageos-3  192.168.50.102  Healthy    Healthy
```

To view the status in more detail there are additional format
options which can be given to the `--format` flag:

- `cp` shows the status of control plane components
- `dp` shows the status of data plane components
- `detailed` shows the status of control plane and data plane components

### `storageos cluster inspect`

To inspect a cluster:
```bash
$ storageos cluster inspect 207f0026-3844-40e0-884b-729d79c124b8
[
    {
        "id": "207f0026-3844-40e0-884b-729d79c124b8",
        "size": 3,
        "createdAt": "2017-07-14T13:17:29.226058526Z",
        "updatedAt": "2017-07-14T13:17:29.22605861Z"
    }
]
```
### `storageos cluster maintenance inspect`
To view the maintenance status of a cluster:
```
$ storageos cluster maintenance inspect
[
    {
        "enabled": false,
        "updatedBy": "",
        "updatedAt": "0001-01-01T00:00:00Z"
    }
]

```

### `storageos cluster rm`

To remove a cluster:
```bash
storageos cluster rm 207f0026-3844-40e0-884b-729d79c124b8
207f0026-3844-40e0-884b-729d79c124b8
```
