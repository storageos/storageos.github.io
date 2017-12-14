---
layout: guide
title: StorageOS Docs - Troubleshooting
anchor: install
module: install/prerequisites/firewalls
---

# Port list

StorageOS requires a few ports to be open in order to function correctly. These ports are:

| Port Number | TCP/UDP   | Use                    |
|:-----------:|:---------:|:---------------------- |
| 5701        | tcp       | gRPC                   |
| 5702        | tcp       | Prometheus             |
| 5703        | tcp       | DirectFS               |
| 5704        | tcp       | Dataplane health check |
| 5705        | tcp       | REST API               |
| 5706        | tcp       | ETCD service           |
| 5707        | tcp       | ETCD service           |
| 5708        | tcp       | NATS service           |
| 5709        | tcp       | NATS service           |
| 5710        | tcp       | NATS service           |
| 5711        | tcp & udp | Gossip service         |

StorageOS also uses random ports to dial-out to these ports on other sotrageOS nodes. For this reason, outgoing traffic should be enabled.


## Firewalls and VPS providers

Some VPS providers (such as Digital Ocean) have some default firewall rules set
which must be updated to allow StorageOS to run.

To configure firewall rules using `UFW` commands:

```bash
ufw default allow outgoing
ufw allow 5701:5711/tcp
ufw allow 5711/udp
```

The equivalent `IPTABLES` commands (assuming `eth0` is correct):

```bash
# Set defaults at the top of the table to allow localhost, outgoing traffic
# and established connections
iptables -I INPUT -i lo -j ACCEPT
iptables -I OUTPUT -o lo -j ACCEPT
iptables -I OUTPUT -o eth0 -d 0.0.0.0/0 -j ACCEPT
iptables -I INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Open required ports

iptables -A INPUT -p tcp --dport 5701:5711 -j ACCEPT
iptables -A INPUT -p udp --dport 5711 -j ACCEPT
```
