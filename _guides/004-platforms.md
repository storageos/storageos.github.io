---
layout: default
title: Platforms
anchor: platforms

sections:
  -
    title: Kubernetes
    description: Kubernetes
    module: platforms/kubernetes
    items:
      -
        title: Install
        description: Install K8S
        module: platforms/kubernetes/install
        subitems:
          -
            title: 1.13
            description: Install on 1.13
            module: platforms/kubernetes/install/1.13
          -
            title: 1.12
            description: Install on 1.12
            module: platforms/kubernetes/install/1.12
          - 
            title: 1.11
            description: Install on 1.10 and 1.11
            module: platforms/kubernetes/install/1.11
          - 
            title: 1.10 <br>
            description: Install on 1.10
            module: platforms/kubernetes/install/1.10
          -
            title: 1.9
            description: Install on 1.9
            module: platforms/kubernetes/install/1.9
          -
            title: 1.8
            description: Install on 1.8
            module: platforms/kubernetes/install/1.8
          -
            title: 1.7
            description: Install on 1.7 and prior
            module: platforms/kubernetes/install/1.7
      -
        title: Troubleshooting
        description: Troubleshooting
        module: platforms/kubernetes/troubleshoot
        subitems:
          -
            title: Installation
            description: Troubleshooting installation
            module: platforms/kubernetes/troubleshoot/install
          -
            title: Volume Provisioning
            description: Troubleshooting volumes
            module: platforms/kubernetes/troubleshoot/volumes
      -
        title: StorageOS Volume Guide
        description: Examples for operations
        module: platforms/kubernetes/firstvolume
      -
        title: Best Practices
        description: Kubernetes best practices
        module: platforms/kubernetes/bestpractices
  - title: OpenShift
    description: Openshift
    module: platforms/openshift
    items:
      -
        title: Install
        description: Install on OpenShift
        module: platforms/openshift/install
        subitems:
          -
            title: 3.11
            description: Install on 3.11
            module: platforms/openshift/install/3.11
          -
            title: "3.10"
            description: Install on 3.10
            module: platforms/openshift/install/3.10
          -
            title: 3.9
            description: Install on 3.9+
            module: platforms/openshift/install/3.9
          -
            title: 3.8
            description: Install on 3.8
            module: platforms/openshift/install/3.8
          -
            title: 3.7 and prior
            description: Install on 3.7 and prior
            module: platforms/openshift/install/3.7
      - 
        title: Troubleshooting
        description: Troubleshooting
        module: platforms/openshift/troubleshoot
        subitems:
          -
            title: Installation
            description: Troubleshooting installation
            module: platforms/openshift/troubleshoot/install
          -
            title: Volume Provisioning
            description: Troubleshooting volumes
            module: platforms/openshift/troubleshoot/volumes
      -
        title: StorageOS Volume Guide
        description: Examples for operations
        module: platforms/openshift/firstvolume
      -
        title: Best Practices
        description: OpenShift best practices
        module: platforms/openshift/bestpractices
  -
    title: Azure AKS
    description: Kubernetes in AKS
    module: platforms/azure-aks
    items:
      -
        title: Install
        description: Install K8S
        module: platforms/azure-aks/install
        subitems:
          -
            title: K8s 1.11
            description: Install on 1.11
            module: platforms/azure-aks/install/1.11
          -
            title: K8s 1.10 <br>
            description: Install on 1.10
            module: platforms/azure-aks/install/1.10
      -
        title: StorageOS Volume Guide
        description: Examples for operations
        module: platforms/azure-aks/firstvolume
      -
        title: Best Practices
        description: Kubernetes best practices
        module: platforms/azure-aks/bestpractices
  - title: Rancher
    description: Rancher
    module: platforms/rancher
    items:
      -
        title: Install
        description: Install on rancher
        module: platforms/rancher/install
        subitems:
          -
            title: Kubernetes
            description: Install on Rancher
            module: platforms/rancher/install/kubernetes
      -
        title: Troubleshooting
        description: Troubleshooting
        module: platforms/rancher/troubleshoot
        subitems:
          -
            title: Installation
            description: Troubleshooting installation
            module: platforms/rancher/troubleshoot/install
          -
            title: Volume Provisioning
            description: Troubleshooting volumes
            module: platforms/rancher/troubleshoot/volumes
      -
        title: StorageOS Volume Guide
        description: Examples for operations
        module: platforms/rancher/firstvolume
      -
        title: Best Practices
        description: rancher best practices
        module: platforms/rancher/bestpractices
  - title: DockerEE
    description: DockerEE/K8S
    module: platforms/dockeree
    items:
      -
        title: Install
        description: Install on dockeree
        module: platforms/dockeree/install
        subitems:
          -
            title: Kubernetes
            description: Install on DockerEE
            module: platforms/dockeree/install/kubernetes
      -
        title: StorageOS Volume Guide
        description: Examples for operations
        module: platforms/dockeree/firstvolume
      -
        title: Best Practices
        description: dockeree best practices
        module: platforms/dockeree/bestpractices
  - title: DockerCE
    description: DockerCE
    module: platforms/dockerce
    items:
      -
        title: Install
        description: Install
        module: platforms/dockerce/install
      - 
        title: Troubleshooting
        description: Troubleshooting
        module: platforms/dockerce/troubleshoot
        subitems:
          -
            title: Installation
            description: Troubleshooting installation
            module: platforms/dockerce/troubleshoot/install
          -
            title: Volume Provisioning
            description: Troubleshooting volumes
            module: platforms/dockerce/troubleshoot/volumes
---
