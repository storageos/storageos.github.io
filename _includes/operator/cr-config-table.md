The following table lists the configurable spec parameters of the StorageOSCluster custom resource and their default values.

| Parameter                                   | Description                                                                                  | Default
| :----------                                 | :-----------                                                                                 | :-------
| `csi.enable`                                | Enable CSI setup                                                                             | `false`
| `csi.enableControllerPublishCreds`          | Enable CSI controller publish credentials                                                    | `false`
| `csi.enableNodePublishCreds`                | Enable CSI node publish credentials                                                          | `false`
| `csi.enableProvisionCreds`                  | Enable CSI provision credentials                                                             | `false`
| `debug`                                     | Enable debug mode for all the cluster nodes                                                  | `false`
| `disableFencing`                            | Disable Pod fencing                                                                          | `false`
| `disableTelemetry`                          | Disable telemetry reports                                                                    | `false`
| `images.csiClusterDriverRegistrarContainer` | CSI Cluster Driver Registrar Container image                                                 | `quay.io/k8scsi/csi-cluster-driver-registrar:v1.0.1`
| `images.csiExternalAttacherContainer`       | CSI External Attacher Container image                                                        | `quay.io/k8scsi/csi-attacher:v1.0.1`
| `images.csiExternalProvisionerContainer`    | CSI External Provisioner Container image                                                     | `storageos/csi-provisioner:v1.0.1`
| `ìmages.csiLivenessProbeContainer`          | CSI Liveness Probe Container Image                                                           | `quay.io/k8scsi/livenessprobe:v1.0.1`
| `images.csiNodeDriverRegistrarContainer`    | CSI Node Driver Registrar Container image                                                    | `quay.io/k8scsi/csi-node-driver-registrar:v1.0.1`
| `images.initContainer`                      | StorageOS init container image                                                               | `storageos/init:0.1`
| `images.nodeContainer`                      | StorageOS node container image                                                               | `storageos/node:1.1.0`
| `ingress.annotations`                       | Annotations of the ingress used by the cluster                                               |
| `ingress.enable`                            | Enable ingress for the cluster                                                               | `false`
| `ingress.hostname`                          | Hostname to be used in cluster ingress                                                       | `storageos.local`
| `ingress.tls`                               | Enable TLS for the ingress                                                                   | `false`
| `kvBackend.address`                         | Comma-separated list of addresses of external key-value store. (`1.2.3.4:2379,2.3.4.5:2379`) |
| `kvBackend.backend`                         | Name of the key-value store to use. Set to `etcd` for external key-value store.              | `embedded`
| `namespace`                                 | Namespace where storageos cluster resources are created                                      | `storageos`
| `nodeSelectorTerms`                         | Set node selector for storageos pod placement                                                |
| `pause`                                     | Pause the operator for cluster maintenance                                                   | `false`
| `resources`                                 | Set resource requirements for the containers                                                 |
| `secretRefName`                             | Reference name of storageos secret                                                           |
| `secretRefNamespace`                        | Namespace of storageos secret                                                                |
| `service.annotations`                       | Annotations of the Service used by the cluster                                               |
| `service.externalPort`                      | External port of the Service used by the cluster                                             | `5705`
| `service.internalPort`                      | Internal port of the Service used by the cluster                                             | `5705`
| `service.name`                              | Name of the Service used by the cluster                                                      | `storageos`
| `service.type`                              | Type of the Service used by the cluster                                                      | `ClusterIP`
| `sharedDir`                                 | Path to be shared with kubelet container when deployed as a pod                              | `/var/lib/kubelet/plugins/kubernetes.io~storageos`
| `tlsEtcdSecretRefName`                      | Secret containing etcd client certificates                                                   |
| `tlsEtcdSecretRefNamespace`                 | Namespace of the tlsEtcdSecretRefName                                                        |
| `tolerations`                               | Set pod tolerations for storageos pod placement                                              |
