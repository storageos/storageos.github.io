#!/bin/bash

export NAMESPACE=storageos-etcd

kubectl delete -n $NAMESPACE etcd storageos-etcd
sleep 5
kubectl delete -n $NAMESPACE deployment etcd-operator
kubectl delete  clusterrolebinding etcd-operator
kubectl delete  clusterrole etcd-operator
kubectl delete namespace $NAMESPACE
