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
ufw allow 5701/tcp
ufw allow 5702/tcp
ufw allow 5703/tcp
ufw allow 5704/tcp
ufw allow 5705/tcp
ufw allow 5706/tcp
ufw allow 5707/tcp
ufw allow 5708/tcp
ufw allow 5709/tcp
ufw allow 5710/tcp
ufw allow 5711/tcp
```

The equivalent `IPTABLES` commands (assuming `eth0` is correct):

```bash
# Set defaults at the top of the table to allow outgoing traffic
iptables -I OUTPUT -o eth0 -d 0.0.0.0/0 -j ACCEPT
iptables -I INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Open required ports

iptables -A INPUT -p tcp --dport 5701 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5701 -j ACCEPT
iptables -A INPUT -p tcp --dport 5702 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5702 -j ACCEPT
iptables -A INPUT -p tcp --dport 5703 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5703 -j ACCEPT
iptables -A INPUT -p tcp --dport 5704 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5704 -j ACCEPT
iptables -A INPUT -p tcp --dport 5705 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5705 -j ACCEPT
iptables -A INPUT -p tcp --dport 5706 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5706 -j ACCEPT
iptables -A INPUT -p tcp --dport 5707 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5707 -j ACCEPT
iptables -A INPUT -p tcp --dport 5708 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5708 -j ACCEPT
iptables -A INPUT -p tcp --dport 5708 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5708 -j ACCEPT
iptables -A INPUT -p tcp --dport 5709 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5709 -j ACCEPT
iptables -A INPUT -p tcp --dport 5710 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5710 -j ACCEPT
iptables -A INPUT -p tcp --dport 5711 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5711 -j ACCEPT
```
