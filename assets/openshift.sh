ssh root@node01.aws.storageos.net
cat /etc/systemd/system/atomic-openshift-node-dep.service
[Unit]
Requires=docker.service
After=docker.service
PartOf=atomic-openshift-node.service
Before=atomic-openshift-node.service

[Service]
ExecStart=/bin/bash -c 'if [[ -f /usr/bin/docker-current ]]; \
 then echo DOCKER_ADDTL_BIND_MOUNTS=\"--volume=/usr/bin/docker-current:/usr/bin/docker-current:ro \
 --volume=/var/lib/storageos:/var/lib/storageos:rshared \
 --volume=/etc/sysconfig/docker:/etc/sysconfig/docker:ro \
 --volume=/etc/containers/registries:/etc/containers/registries:ro \
 \" > \
 /etc/sysconfig/atomic-openshift-node-dep; \
 else echo "#DOCKER_ADDTL_BIND_MOUNTS=" > /etc/sysconfig/atomic-openshift-node-dep; fi'
ExecStop=
SyslogIdentifier=atomic-openshift-node-dep
