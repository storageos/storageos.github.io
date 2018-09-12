---
layout: guide
title: StorageOS Docs - Docker container
anchor: platforms
module: platforms/docker/install
redirect_from: /docs/install/docker/container
redirect_from: install/docker/container
---

# Installation

* Ensure that our prerequisites are met, paying particular attention to [system
  configuration]({% link _docs/prerequisites/systemconfiguration.md %}) and [mount
  propagation]({% link _docs/prerequisites/mountpropagation.md %})
* Run a docker container as follows:
```bash
/usr/bin/docker run \
    --name=storageos \
    --env=HOSTNAME=$(hostname) \
    --env=ADVERTISE_IP=127.0.0.1 \
    --env=JOIN=127.0.0.1 \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add=SYS_ADMIN \
    --device=/dev/fuse \
    --volume=/var/lib/storageos:/var/lib/storageos:rshared \
    --volume=/run/docker/plugins:/run/docker/plugins \
    --volume=/sys:/sys \
    storageos/node:{{ site.latest_node_version }}
```
* With the StorageOS [CLI]({% link _docs/reference/cli/index.md %}) installed, create
  a test volume:
```bash
export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos STORAGEOS_HOST=127.0.0.1
/usr/local/bin/storageos volume create myvol
```
* Run a container with the volume presented
```bash
/usr/bin/docker run \
    --interactive \
    --tty \
    --volume-driver=storageos \
    --volume=myvol:/data \
    busybox sh
```

*n.b. StorageOS supports a number of environment variables to tune its
behaviour. See the [Environment Variables]({% link _docs/reference/envvars.md
%}) section for more details.*

# Running as a systemd service
For some deployments, it is useful to run storageos as a service under systemd
control. We provide a sample manifest and associated scripts on github to
automate this.

```bash
# Install StorageOS managed by systemd, using Ansible
git clone https://github.com/storageos/deploy.git storageos
cd storageos/systemd-service/deploy-storageos-ansible

# Update hosts to your hostnames and ip addresses
nano hosts
ansible-playbook -i hosts site.yaml
```

