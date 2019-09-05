## Upgrade StorageOS Operator using Helm

If you have installed the StorageOS Operator using the [Helm Chart](https://github.com/storageos/charts/tree/master/stable/storageos-operator#installing-the-chart), then you can upgrade the operator using the following commands.

```
$ helm list

NAME            REVISION        STATUS          CHART                           APP VERSION     NAMESPACE   
storageos-v1   4               DEPLOYED        storageos-operator-0.2.11       1.3.0           storageos-operator
```

```
$ helm repo update
$ helm upgrade $NAME storageos/storageos-operator
```

>  When you run the above command StorageOS Operator resources will be updated.
>  Since, the Update Strategy of the StorageOS Operator Deployment is set to
>  rolling update, a new StorageOS Operator Pod will be created. Only when
>  the new Pod enters the Running Phase will the old Pod be deleted.
>  Your StorageOS Cluster will not be affected while the StorageOS
>  Operator is upgrading.
