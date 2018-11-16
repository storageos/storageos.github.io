The following table lists the configurable spec parameters of the StorageOSCluster custom resource and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`secretRefName`                          | Reference name of storageos secret                                                                                   |
`secretRefNamespace`                     | Namespace of storageos secret                                                                                        |
`namespace`                              | Namespace where storageos cluster resources are created                                                              | `storageos`
`images.nodeContainer`                   | StorageOS node container image                                                                                       | `storageos/node:1.0.0`
`images.initContainer`                   | StorageOS init container image                                                                                       | `storageos/init:0.1`
`images.csiDriverRegistrarContainer`     | CSI Driver Registrar Container image                                                                                 | `quay.io/k8scsi/driver-registrar:v0.2.0`
`images.csiExternalProvisionerContainer` | CSI External Provisioner Container image                                                                             | `quay.io/k8scsi/csi-provisioner:v0.3.0`
`images.csiExternalAttacherContainer`    | CSI External Attacher Container image                                                                                | `quay.io/k8scsi/csi-attacher:v0.3.0`
`csi.enable`                             | Enable CSI setup                                                                                                     | `false`
`csi.enableProvisionCreds`               | Enable CSI provision credentials                                                                                     | `false`
`csi.enableControllerPublishCreds`       | Enable CSI controller publish credentials                                                                            | `false`
`csi.enableNodePublishCreds`             | Enable CSI node publish credentials                                                                                  | `false`
`service.name`                           | Name of the Service used by the cluster                                                                              | `storageos`
`service.type`                           | Type of the Service used by the cluster                                                                              | `ClusterIP`
`service.externalPort`                   | External port of the Service used by the cluster                                                                     | `5705`
`service.internalPort`                   | Internal port of the Service used by the cluster                                                                     | `5705`
`service.annotations`                    | Annotations of the Service used by the cluster                                                                       |
`ingress.enable`                         | Enable ingress for the cluster                                                                                       | `false`
`ingress.hostname`                       | Hostname to be used in cluster ingress                                                                               | `storageos.local`
`ingress.tls`                            | Enable TLS for the ingress                                                                                           | `false`
`ingress.annotations`                    | Annotations of the ingress used by the cluster                                                                       |
`sharedDir`                              | Path to be shared with kubelet container when deployed as a pod (`/var/lib/kubelet/plugins/kubernetes.io~storageos`) |
`kvBackend.address`                      | Comma-separated list of addresses of external key-value store. (`1.2.3.4:2379,2.3.4.5:2379`)                         |
`kvBackend.backend`                      | Name of the key-value store to use. Set to `etcd` for external key-value store.                                      | `embedded`
`pause`                                  | Pause the operator for cluster maintenance                                                                           | `false`
`debug`                                  | Enable debug mode for all the cluster nodes                                                                          | `false`
`nodeSelectorTerms`                      | Set node selector for storageos pod placement                                                                        |
`resources`                              | Set resource requirements for the containers                                                                         |
