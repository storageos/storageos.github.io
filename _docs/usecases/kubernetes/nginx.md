---
layout: guide
title: StorageOS Docs - Nginx
anchor: usecases
module: usecases/kubernetes/nginx
---

# ![image](/images/docs/explore/nginxlogo.png) Nginx with StorageOS

Nginx is a popular web server that can be used as a reverse proxy, load
balancer or even as a
[Kubernetes ingress controller.]{https://github.com/kubernetes/ingress-nginx}

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. [See our guide on how to install StorageOS on Kubernetes for more
information]({% link _docs/platforms/kubernetes/install/index.md %})

## Deploying Nginx on Kubernetes

1. You can find the latest files in the StorageOS example deployment repostiory
   ```bash
   git clone https://github.com/storageos/deploy.git storageos
   ```
   StatefulSet defintion
  ```yaml
   apiVersion: apps/v1
   kind: StatefulSet
   metadata:
    name: nginx
   spec:
     serviceName: nginx
       spec:
         serviceAccountName: nginx
         containers:
         - name: nginx
           image: nginx
           ports:
           - containerPort: 80
           volumeMounts:
           - name: nginx-data
             mountPath: /usr/share/nginx
           - name: nginx-config
             mountPath: /etc/nginx/conf.d
         volumes:
         - name: nginx-config
           configMap:
             name: nginx
       volumeClaimTemplates:
       - metadata:
         name: nginx-data
         spec:
           accessModes: ["ReadWriteOnce"]
           storageClassName: "fast" # StorageOS storageClass 
             resources:
               requests:
                 storage: 5Gi
 ```
   This excerpt is from the StatefulSet definition. This file contains the
   VolumeClaim template that will dynamically provision storage, using the
   StorageOS storage class. Dynamic provisioning occurs as a volumeMount has
   been declared with the same name as a VolumeClaim.

1. Move into the Nginx examples folder and create the objects

   ```bash
   cd storageos
   kubectl create -f ./k8s/examples/nginx
   ```

1. Confirm Nginx is up and running.

   ```bash
   $ kubectl get pods -w -l app=nginx
   NAME        READY    STATUS    RESTARTS    AGE
   nginx-0     1/1      Running    0          1m
   ```

1. Connect to the Busybox pod and connect to the Nginx server through the
   service
   ```bash
   $ kubectl exec -it busybox -- /bin/sh 
   / # /bin/busybox wget nginx
   Connecting to nginx (100.65.25.183:80)
   index.html           100% |**********************************************************************|   367  0:00:00 ETA
   / # cat index.html
   <html>
   <head><title>Index of /</title></head>
   <body>
   <h1>Index of /</h1><hr><pre><a href="../">../</a>
   <a href="helloworld.txt">helloworld.txt</a>                                     06-Nov-2018 14:42                  12
   <a href="test.txt">test.txt</a>                                           06-Nov-2018 14:54                  16
   </pre><hr></body>
   </html>
   ```

Depending on what files you have written to the StorageOS volume the output of
the index file will be different. In the example above two txt files were
present on the volume.
   ```

## Configuration

If you need custom startup options, you can edit the ConfigMap file
(15-nginx-configmap.yaml) with your desired Nginx configuration settings.
