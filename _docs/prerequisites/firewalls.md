---
layout: guide
title: StorageOS Docs - Firewalls
anchor: prerequisites
module: prerequisites/firewalls
---

# Port list

StorageOS daemons listen on specific ports, which we require to be accessible
between all nodes in the cluster:

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

StorageOS also uses [ephemeral](https://en.wikipedia.org/wiki/Ephemeral_port) ports to dial-out to these ports on other StorageOS nodes. For this reason, outgoing traffic should be enabled.


## Firewalls and VPS providers

Some VPS providers (such as Digital Ocean) ship default firewall rulesets which
must be updated to allow StorageOS to run. Some example rules are shown below -
modify to taste.



### UFW
For distributions using UFW, such as RHEL and derivatives:

```bash
ufw default allow outgoing
ufw allow 5701:5711/tcp
ufw allow 5711/udp
```

### Firewalld

For distributions that enable firewalld to control iptables such as some installations of OpenShift.

```bash
firewall-cmd --permanent  --new-service=storageos
firewall-cmd --permanent  --service=storageos --add-port=5700-5800/tcp
firewall-cmd --add-service=storageos  --zone=public --permanent
firewall-cmd --reload
```

### Iptables
For those using plain iptables:

```bash
# Inbound traffic
iptables -I INPUT -i lo -m comment --comment 'Permit loopback traffic' -j ACCEPT
iptables -I INPUT -m state --state ESTABLISHED,RELATED -m comment --comment 'Permit established traffic' -j ACCEPT
iptables -A INPUT -p tcp --dport 5701:5711 -m comment --comment 'StorageOS' -j ACCEPT
iptables -A INPUT -p udp --dport 5711 -m comment --comment 'StorageOS' -j ACCEPT

# Outbound traffic
iptables -I OUTPUT -o lo -m comment --comment 'Permit loopback traffic' -j ACCEPT
iptables -I OUTPUT -d 0.0.0.0/0 -m comment --comment 'Permit outbound traffic' -j ACCEPT
```



