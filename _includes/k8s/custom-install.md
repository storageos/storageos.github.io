## Custom Installations

There are a variety of flavours, versions and particularities in the container
orchestrator scope. Because of this, StorageOS installation procedures aim to
be flexible so it can fit different needs regarding the environment,
preferences or requirements. The StorageOS cluster operator makes the
installation easier by delegating the responsibility of the installation to its
logic. If you want to see and alter the installation of StorageOS, the
following examples give you that capacity. Feel free to extend and modify the
publicly available examples.

### Installation with Native Drivers (default)

The following github repository hosts installation examples.

```bash
git clone https://github.com/storageos/deploy.git storageos
cd storageos/k8s/deploy-storageos
```

You can see examples available such as `standard`, `CSI (Container Storage
Interface)` or `etcd-as-svc`. All of them have a `deploy-storageos.sh` that
serves as a wrapper to trigger the manifest creation. Follow the according
`README.md` for each one of them for more details. For advanced installations,
it is recommended to use `etcd-as-svc` that will guide the user to deploy
StorageOS using a etcd cluster deployed by the official Kubernetes
[etcd operator](https://github.com/coreos/etcd-operator).


### Helm installation

StorageOS can be installed with Helm. Helm adds versatility to the installation
method. Default values can be overridden in the command line or you can edit
the `values.yaml` of the Chart. These parameters allow the installation to be
defined using Native Drivers or CSI. To see the full list of options, check
the [parameter
table](https://github.com/storageos/charts/tree/master/stable/storageos#configuration).

```bash
helm repo add storageos https://charts.storageos.com
helm repo update
# Set cluster.join to hostnames or ip addresses of at least one node
helm install storageos/storageos                               \ 
    --name=my-release                                          \
    --version={{ page.chart-version }}                                            \
    --namespace=storageos                                      \
    --set cluster.join=node01,node02,node03                    \
    --set csi.enable=true # Set to false to use Native Drivers
```

> The Helm Chart can be found in the StorageOS [Charts
> repository](https://github.com/storageos/charts)
