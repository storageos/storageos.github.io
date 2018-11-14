### Helm installation

StorageOS can be installed with Helm. Helm adds versatility to the installation
method. Default values can be overridden in the command line or you can edit
the `values.yaml` of the Chart and pass it to the helm install command. These
parameters allow the installation to be defined using Native Drivers or CSI. To
see the full list of options, check
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
    --set cluster.join="node01\,node02\,node03"                \
    --set csi.enable=true # Set to false or remove line to use Native Drivers
```

> The Helm Chart can be found in the StorageOS [Charts
> repository](https://github.com/storageos/charts/tree/master/stable/storageos)
