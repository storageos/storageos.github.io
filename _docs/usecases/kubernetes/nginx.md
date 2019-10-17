---
layout: guide
title: StorageOS Docs - Nginx
anchor: usecases
module: usecases/kubernetes/nginx
---

# ![image](/images/docs/explore/nginxlogo.png) Nginx with StorageOS

[Nginx](https://www.nginx.com/) is a popular web server that can be used as a reverse proxy, load
balancer or even as a
[Kubernetes ingress controller.](https://github.com/kubernetes/ingress-nginx)

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. [See our guide on how to install StorageOS on Kubernetes for more
information]({% link _docs/platforms/kubernetes/install/index.md %}).

## Deploying Nginx on Kubernetes

1. You can find the latest files in the StorageOS use cases repostiory
   ```bash
   git clone https://github.com/storageos/use-cases.git storageos-usecases
   ```
   StatefulSet definition
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
             mountPath: /usr/share/nginx/html
             subPath: html
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
   cd storageos-usecases
   kubectl create -f ./nginx
   ```

1. Confirm Nginx is up and running.

   ```bash
   $ kubectl get pods -w -l app=nginx
   NAME        READY    STATUS    RESTARTS    AGE
   nginx-0     1/1      Running    0          1m
   ```

1. Connect to the nginx pod and write a file to /usr/share/nginx/html that
   Nginx
   will serve.

   ```bash
   $ kubectl exec nginx-0 -it -- bash
   root@nginx-0:/# echo Hello world! > /usr/share/nginx/html/greetings.txt
   ```

1. Connect to the Busybox pod and connect to the Nginx server through the
   service and retrieve the directory index from Nginx.
    ```bash
    $ kubectl exec -it busybox -- /bin/sh
    / # wget -q -O- nginx
    <html>
    <head><title>Index of /</title></head>
    <body>
    <h1>Index of /</h1><hr><pre><a href="../">../</a>
    <a href="greetings.txt">greetings.txt</a>
    27-Feb-2019 12:04                  13
    </pre><hr></body>
    </html>
    ```

1. Retrieve and display the contents of the greetings.txt file
    ```bash
    / # wget -q -O- nginx/greetings.txt
    Hello world!
    ```

## Configuration

If you need custom startup options, you can edit the ConfigMap file
[15-nginx-configmap.yaml](https://github.com/storageos/use-cases/blob/master/nginx/15-configmap.yaml)
with your desired Nginx configuration settings.
