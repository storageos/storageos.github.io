#!/bin/bash

set -euo pipefail

echo "Removing StorageOS Data Directory..."

export NAMESPACE=kube-system

kubectl -n $NAMESPACE create -f-<<END
kind: DaemonSet
apiVersion: apps/v1
metadata:
  name: storageos-cleanup
spec:
  selector:
    matchLabels:
      app: storageos-cleanup
  template:
    metadata:
      name: storageos-cleanup
      labels:
        app: storageos-cleanup
    spec:
      containers:
      - name: storageos-volume-cleanup
        image: "busybox:latest"
        imagePullPolicy: IfNotPresent
        command:
          - "/bin/sh"
        args:
          - "-c"
          - "if [ -d /var/lib/storageos ]; then umount -f /var/lib/storageos || true; rm -rf /var/lib/storageos/; umount -f /var/lib/kubelet/plugins_registry/storageos || true; fi"
        securityContext:
          privileged: true
        volumeMounts:
          - name: state
            mountPath: /var/lib
            mountPropagation: Bidirectional
      volumes:
      - name: state
        hostPath:
          path: /var/lib
END

sleep 20

kubectl -n $NAMESPACE delete ds storageos-cleanup
