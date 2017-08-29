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
| 5705        | tcp       | REST API               |
| 5706        | tcp       | ETCD service           |
| 5707        | tcp       | ETCD service           |
| 8001        | tcp       | Dataplane health check |
| 4222        | tcp       | NATS service           |
| 4223        | tcp       | NATS service           |
| 8222        | tcp       | NATS service           |
| 13701       | tcp & udp | Gossip service         |
| 17100       | tcp       | Direct FS              |
| 17102       | tcp       | Direct FS              |

StorageOS also uses random ports to dial-out to these ports on other sotrageOS nodes. For this reason, outgoing traffic should be enabled.


## Firewalls and VPS providers

Some VPS providers (such as Digital Ocean) have some default firewall rules set which must be updated to allow StorageOS to run.

As many of these hosting providers seem to be using `UFW` as a firewall, here is a list of commands to configure `UFW` to allow StorageOS:

```bash
ufw default allow outgoing
ufw allow 5705/tcp
ufw allow 5706/tcp
ufw allow 5707/tcp
ufw allow 8001/tcp
ufw allow 4222/tcp
ufw allow 4223/tcp
ufw allow 8222/tcp
ufw allow 13701/tcp
ufw allow 13701/udp
ufw allow 17100/tcp
ufw allow 17102/tcp
```

And here is the same as `IPTABLES` commands (assuming `eth0` is correct):

```bash
# Set defaults at the top of the table to allow outgoing traffic
iptables -I OUTPUT -o eth0 -d 0.0.0.0/0 -j ACCEPT
iptables -I INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Append rules to open required ports
# API
iptables -A INPUT -p tcp --dport 5705 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5705 -j ACCEPT

# ETCD
iptables -A INPUT -p tcp --dport 5706 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5706 -j ACCEPT
iptables -A INPUT -p tcp --dport 5707 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5707 -j ACCEPT

# Dataplane health check
iptables -A INPUT -p tcp --dport 8001 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8001 -j ACCEPT

# NATS
iptables -A INPUT -p tcp --dport 4222 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 4222 -j ACCEPT
iptables -A INPUT -p tcp --dport 4223 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 4223 -j ACCEPT
iptables -A INPUT -p tcp --dport 8222 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8222 -j ACCEPT

# Gossip
iptables -A INPUT -p tcp --dport 13701 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 13701 -j ACCEPT
iptables -A INPUT -p udp --dport 13701 -j ACCEPT
iptables -A OUTPUT -p udp --dport 13701 -j ACCEPT

# DirectFS
iptables -A INPUT -p tcp --dport 17100 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 17100 -j ACCEPT
iptables -A INPUT -p tcp --dport 17102 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 17102 -j ACCEPT
```
