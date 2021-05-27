#!/bin/bash
#############################################################################
# Script Name  :   deploy-storageos-cluster.sh                                                                                           
# Description  :   Install StorageOS Self-Evaluation Cluster                                                                              
# Args         :   
# Author       :   StorageOS
# Issues       :   Issues&PR https://github.com/storageos/storageos.github.io
#############################################################################

set -euo pipefail

# StorageOS Self-Evaluation This script will install StorageOS onto a
# Kubernetes cluster
# 
# This script is based on the installation instructions in our self-evaluation
# guide: https://docs.storageos.com/docs/self-eval. Please see that guide for
# more information.
# 
# Expectations:
# - Kubernetes cluster with a minium of 3
#   nodes
# - kubectl in the PATH - kubectl access to this cluster with
#   cluster-admin privileges - export KUBECONFIG as appropriate

# The following variables may be tuned as desired. The defaults should work in
# most environments.

# Getting the latest and greatest to deploy as a self-evaluation.
# Failing back to a manual entry if cURL not present (I know!).
if ! command -v curl &> /dev/null 
then
    OPERATOR_VERSION='v2.4.0-rc.1'
else
    OPERATOR_VERSION=`curl --silent "https://api.github.com/repos/storageos/cluster-operator/releases/latest" |awk -F '"' '/tag_name/{print $4}'`
fi
STORAGEOS_OPERATOR_LABEL='name=storageos-cluster-operator'
STOS_NAMESPACE='kube-system'
ETCD_NAMESPACE='storageos-etcd'
STOS_CLUSTERNAME='self-evaluation'

while getopts c:v:l: option
do
    case "${option}" in 
        c) STOS_CLUSTERNAME=${OPTARG};;
        v) OPERATOR_VERSION=${OPTARG};;
        l) 
  esac
done
CLI_VERSION=${OPERATOR_VERSION}
STOS_VERSION=${OPERATOR_VERSION}


# Define some colours for later
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# spin the wheel to avoid nervous breakdown during waiting time
sp="/-\|"
spin() {
    printf '\b%.1s' "$sp"
    sp=${sp#?}${sp%???}
}
endspin() {
    echo -ne '\b \b'
}

# Welcoming STORAGEOS users :)
echo 
echo -e "${RED}Welcome to the ${NC}STORAGE${GREEN}OS${RED} self-evaluation installation script.${NC}"
echo -e "${GREEN}Self-Evaluation guide: https://docs.storageos.com/docs/self-eval${NC}"
echo -e "   ${RED}This deployment is suitable for testing purposes only.${NC}"
echo 

# Checking and exiting if requirements are not met.
echo -e "${GREEN}Checking requirements:${NC}"

# Checking if kubectl is present!
echo -ne "  Checking Kubectl......................................"
if ! command -v kubectl &> /dev/null 
then
    echo -ne "${RED}NOK${NC}\n"
    echo -e "${RED}    Kubectl could not be found on this shell.${NC}"
    echo -e "${RED}    Kubectl is used to access Kubernetes clusters and is required.${NC}"
    echo -e "${RED}    Please intall kubectl: https://kubernetes.io/docs/tasks/tools/${NC}"
    exit
fi 
echo -ne ".${GREEN}OK${NC}\n"

# Checking for the minimum node count (3)
echo -ne "  Checking node count (minimum 3)......................."
NODECOUNT=`kubectl get nodes -o name | wc -l`
if [ ${NODECOUNT} -lt 3 ]
then 
    echo -ne "${RED}NOK${NC}\n" 
    exit
fi 
echo -ne ".${GREEN}OK${NC} (${RED}${NODECOUNT}${NC})\n"

# Checking for an existing STORAGEOS cluster on the kubernetes target
echo -ne "  Checking for exiting STORAGE${GREEN}OS${NC} cluster................"
if kubectl get storageoscluster --all-namespaces -o name &>/dev/null;
then
    echo -ne "${RED}YES${NC}\n"
    echo -e "  ${RED}/!\ ${NC}STORAGE${GREEN}OS ${NC}cluster${RED} already deployed on this Kubernetes cluster."
    echo
    exit
    # todo: include a clean-up option from this breaking point
else 
    echo -ne ".${GREEN}NO${NC}\n"
fi

# Summary of what is on the menu for deployment today
echo 
echo -e "${GREEN}The script will deploy a ${NC}STORAGE${GREEN}OS cluster: ${NC}"
echo -e "  STORAGE${GREEN}OS${NC} cluster named ${RED}${STOS_CLUSTERNAME}${GREEN}.${NC}"
echo -e "  STORAGE${GREEN}OS${NC} version ${RED}${STOS_VERSION}${NC} into namespace ${RED}${STOS_NAMESPACE}${GREEN}.${NC}"

# RC? Let's have a bit of a warning there
if [[ ${STOS_VERSION} =~ .*rc.* ]];
then 
  echo -e "    ${RED}/!\ ${STOS_VERSION}${NC}: Release Candidate are not intended for production deployment.${NC}" 
fi
# not deploying in kube-system - brace yourself!
if [[ ! "${STOS_NAMESPACE}" == "kube-system" ]];
then 
  echo -e "    ${RED}/!\ ${NC}only ${RED}kube-system${NC} namespace namespace for ease of self-evualation.${NC}" 
  exit
fi

echo -e "  etcd into namespace ${RED}${ETCD_NAMESPACE}${GREEN}.${NC}"
# not deploying in storageos-etcd - brace yourself!
if [[ ! "${ETCD_NAMESPACE}" == "storageos-etcd" ]];
then 
  echo -e "    ${RED}/!\ ${NC}only ${RED}storageos-etcd${NC} namespace for ease of self-evualation.${NC}" 
  exit
fi
echo -e "${GREEN}The installation process will stop on any encountered error.${NC}"
echo

# Having the courtesy to check if happy with the basics settings
read < /dev/tty -n1 -r -p "Proceed with these settings? (y/n) "

echo 
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo 
    echo -e "Usage: ./deploy-storageos-cluster.sh [OPTION]..."
    echo -e "${RED}Install a ${NC}STORAGE${GREEN}OS${RED} Self-Evaluation cluster on Kubernetes.${NC}"
    echo 
    echo -e "  -c       ${NC}STORAGE${GREEN}OS${NC} cluser name."
    echo -e "  -v       ${NC}STORAGE${GREEN}OS${NC} version to deploy."
    echo -e "           Check https://github.com/storageos/cluster-operator/releases"
    echo 
    echo "Eg: ./deploy-storageos-cluster.sh -c demo-cluster -v ${STOS_VERSION}"
    echo "    curl -fsSL https://storageos.run | bash -s -- -c demo-cluster -v ${STOS_VERSION}"
    echo
    echo "Issues: https://github.com/storageos/storageos.github.io"
    echo
    exit
fi

# Starting deployment
echo -e "${GREEN}Starting ${NC}STORAGE${GREEN}OS deployment:${NC}"
echo -ne "  Is it OpenShift?......................................"

# If running in Openshift, an SCC is needed to start Pods
if grep -q "openshift" <(kubectl get node --show-labels); 
then
    echo -ne "${GREEN}YES${NC}\n"

    # Checking if OCP CLI is present!
    echo -ne "  Checking OCP CLI......................................"
    if ! command -v oc &> /dev/null 
    then
        echo -ne "${RED}NOK${NC}\n"
        echo -e "${RED}    OCP CLI (oc) could not be found on this shell.${NC}"
        echo -e "${RED}    Please intall OCP CLI: https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html/${NC}"
        exit
    fi 
    echo -ne ".${GREEN}OK${NC}\n"

    echo -ne "  OpenShift  - adding SCC for ${RED}${ETCD_NAMESPACE}${GREEN}${NC} ............"
    oc adm policy add-scc-to-user anyuid \
    system:serviceaccount:${ETCD_NAMESPACE}:default
    sleep 5
    echo -ne "${GREEN}OK${NC}\n"
fi
echo -ne ".${GREEN}NO${NC}\n"

# First, we create an etcd cluster. Our example uses the CoreOS operator to
# create a 3 pod cluster using transient storage. This is *unsuitable for
# production deployments* but fine for evaluation purposes. The data in the
# etcd will not persist outside of a reboot.

echo -ne "  Creating etcd namespace................................"
kubectl create namespace ${ETCD_NAMESPACE} 1> /dev/null
echo -ne "${GREEN}OK${NC} (${RED}${ETCD_NAMESPACE}${NC})\n"

echo -ne "  Creating etcd ClusterRoleBinding......................"
kubectl -n ${ETCD_NAMESPACE} create -f- 1>/dev/null<<END
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: etcd-operator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: etcd-operator
subjects:
- kind: ServiceAccount
  name: default
  namespace: ${ETCD_NAMESPACE}
---
END

echo -ne ".${GREEN}OK${NC}\n"


echo -ne "  Creating etcd ClusterRole............................."
kubectl -n ${ETCD_NAMESPACE} create -f- 1>/dev/null<<END
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: etcd-operator
rules:
- apiGroups:
  - etcd.database.coreos.com
  resources:
  - etcdclusters
  - etcdbackups
  - etcdrestores
  verbs:
  - "*"
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - "*"
- apiGroups:
  - ""
  resources:
  - pods
  - services
  - endpoints
  - persistentvolumeclaims
  - events
  verbs:
  - "*"
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - "*"
# The following permissions can be removed if not using S3 backup and TLS
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
---
END

echo -ne ".${GREEN}OK${NC}\n"


# Create etcd operator Deployment - this will deploy and manage the etcd
# instances
echo -ne "  Creating etcd operator deployment....................."
kubectl -n ${ETCD_NAMESPACE} create -f- 1>/dev/null<<END
apiVersion: apps/v1
kind: Deployment
metadata:
  name: etcd-operator
spec:
  replicas: 1
  selector:
    matchLabels:
      name: etcd-operator
  template:
    metadata:
      labels:
        name: etcd-operator
    spec:
      containers:
      - name: etcd-operator
        image: quay.io/coreos/etcd-operator:v0.9.4
        command:
        - etcd-operator
        env:
        - name: MY_POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
END

echo -ne ".${GREEN}OK${NC}\n"

# Wait for etcd operator to become ready
echo -ne "    Waiting on etcd operator to be running..............."
until phase=`kubectl -n ${ETCD_NAMESPACE} get pod -lname=etcd-operator --no-headers -ocustom-columns=status:.status.phase |grep -q "Running" 1>/dev/null`; 
do
   spin
done
endspin
echo -ne ".${GREEN}OK${NC}\n"


# Create etcd CustomResource
# This will install 3 etcd pods into the cluster using ephemeral storage. It
# will also create a service endpoint, by which we can refer to the cluster in
# the installation for StorageOS itself below.
echo -ne "  Creating etcd cluster................................."
kubectl -n ${ETCD_NAMESPACE} create -f- 1>/dev/null<<END
apiVersion: "etcd.database.coreos.com/v1beta2"
kind: "EtcdCluster"
metadata:
  name: "storageos-etcd"
spec:
  size: 3
  version: "3.4.9"
  pod:
    etcdEnv:
    - name: ETCD_QUOTA_BACKEND_BYTES
      value: "2589934592"  # ~2 GB
    - name: ETCD_AUTO_COMPACTION_MODE
      value: "revision"
    - name: ETCD_AUTO_COMPACTION_RETENTION
      value: "1000"
#  Modify the following requests and limits if required
#    requests:
#      cpu: 2
#      memory: 4G
#    limits:
#      cpu: 2
#      memory: 4G
    resources:
      requests:
        cpu: 200m
        memory: 300Mi
    securityContext:
      runAsNonRoot: true
      runAsUser: 9000
      fsGroup: 9000
# The following toleration allows us to run on a master node - modify to taste
#  Tolerations example
#    tolerations:
#    - key: "role"
#      operator: "Equal"
#      value: "etcd"
#      effect: "NoExecute"
    affinity:
      podAntiAffinity:
        preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          podAffinityTerm:
            labelSelector:
              matchExpressions:
              - key: etcd_cluster
                operator: In
                values:
                - storageos-etcd
            topologyKey: kubernetes.io/hostname
END

echo -ne ".${GREEN}OK${NC}\n"


# Now that we have an etcd cluster starting, we need to install the StorageOS
# operator, which will manage the install of StorageOS itself.
echo -ne "  Creation STORAGE${GREEN}OS${NC} operator deployment................"
kubectl create --filename=https://github.com/storageos/cluster-operator/releases/download/${OPERATOR_VERSION}/storageos-operator.yaml 1>/dev/null

echo -ne ".${GREEN}OK${NC} (${RED}${OPERATOR_VERSION}${NC})\n"


# Wait for the operator to become ready
echo -ne "    Waiting on STORAGE${GREEN}OS${NC} operator to be running.........."
# phase="$(kubectl -n storageos-operator get pod -l${STORAGEOS_OPERATOR_LABEL} --no-headers -ocustom-columns=status:.status.phase)"
# while ! grep -q "Running" <(echo "${phase}"); do
#     sleep 2
#     phase="$(kubectl -n storageos-operator get pod -l${STORAGEOS_OPERATOR_LABEL} --no-headers -ocustom-columns=status:.status.phase)"
# done
# echo -ne ".${GREEN}OK${NC}\n"

until phase=`kubectl -n storageos-operator get pod -l${STORAGEOS_OPERATOR_LABEL} --no-headers -ocustom-columns=status:.status.phase |grep -q "Running" 1>/dev/null`; 
do
   spin
done
endspin
echo -ne ".${GREEN}OK${NC}\n"



# The StorageOS secret contains credentials for our API, as well as CSI
echo -ne "  Creating STORAGE${GREEN}OS${NC} API secret........................."
kubectl create -f- 1>/dev/null<<END
apiVersion: v1
kind: Secret
metadata:
 name: "storageos-api"
 namespace: "storageos-operator"
 labels:
   app: "storageos"
type: "kubernetes.io/storageos"
data:
 # echo -n '<secret>' | base64
 apiUsername: c3RvcmFnZW9z
 apiPassword: c3RvcmFnZW9z
 # CSI Credentials
 csiProvisionUsername: c3RvcmFnZW9z
 csiProvisionPassword: c3RvcmFnZW9z
 csiControllerPublishUsername: c3RvcmFnZW9z
 csiControllerPublishPassword: c3RvcmFnZW9z
 csiNodePublishUsername: c3RvcmFnZW9z
 csiNodePublishPassword: c3RvcmFnZW9z
 csiControllerExpandUsername: c3RvcmFnZW9z
 csiControllerExpandPassword: c3RvcmFnZW9z
END

echo -ne ".${GREEN}OK${NC}\n"

# Now that we have the operator installed, and a secret defined, it is time to
# install StorageOS itself. We default to the kube-system namespace, which
# gives us some protection against eviction by the Kubelet under conditions of
# contention.

# interesting? if there is a STOS_NAMESPACE variable to mangle, should we not 
# offer the capabilities; this is a testing environment, let's have users testing
# this. 
# not deploying in kube-system - brace yourself!
if [[ ! "${STOS_NAMESPACE}" == "kube-system" ]];
then 
  echo -ne "  Creating STORAGE${GREEN}OS${NC} cluster namespace........"
  kubectl create namespace ${STOS_NAMESPACE} 1>/dev/null
  echo -ne ".${GREEN}OK${NC} (${RED}${STOS_NAMESPACE}${NC})\n"
fi

# In the StorageOS CR we declare the DNS name for the etcd deployment and
# service we created earlier.
echo -ne "  Creating STORAGE${GREEN}OS${NC} cluster............................"
kubectl create -f- 1>/dev/null<<END
---
apiVersion: storageos.com/v1
kind: StorageOSCluster
metadata:
 name: ${STOS_CLUSTERNAME}
 namespace: ${STOS_NAMESPACE}
spec:
 secretRefName: "storageos-api"
 secretRefNamespace: "storageos-operator"
 k8sDistro: "upstream"  # Set the Kubernetes distribution for your cluster (upstream, eks, aks, gke, rancher, dockeree, openshift)
 images:
   nodeContainer: "storageos/node:${STOS_VERSION}" # StorageOS version
 # storageClassName: fast # The storage class creates by the StorageOS operator is configurable
 kvBackend:
   address: "storageos-etcd-client.${ETCD_NAMESPACE}.svc:2379"
END

echo -ne ".${GREEN}OK${NC} (${RED}${STOS_NAMESPACE}${NC})\n"

# echo -ne "  Waiting on STORAGE${GREEN}OS${NC} pods to be running"
# phase="$(kubectl --namespace=${STOS_NAMESPACE} describe storageoscluster ${STOS_CLUSTERNAME})"
# while ! grep -q "Running" <(echo "${phase}"); do
#     echo -ne "."
#     sleep 10
#     phase="$(kubectl --namespace=${STOS_NAMESPACE} describe storageoscluster ${STOS_CLUSTERNAME})"
# done

# echo -ne ".${GREEN}OK${NC}\n"


printf "    Waiting on STORAGE${GREEN}OS${NC} pods to be running.............."
until phase=`kubectl --namespace=${STOS_NAMESPACE} describe storageoscluster ${STOS_CLUSTERNAME} |grep -q "Running" 1>/dev/null`; 
do
   spin
done
endspin
echo -ne ".${GREEN}OK${NC}\n"


# Now that we have a working StorageOS cluster, we can deploy a pod to run the
# cli inside the cluster. When we want to access the cli, we can kubectl exec
# into this pod.
echo -ne "  Deploying STORAGE${GREEN}OS${NC} CLI as a pod......................"
kubectl create -f- 1>/dev/null<<END
---
apiVersion: v1
kind: Pod
metadata:
 name: cli
 namespace: ${STOS_NAMESPACE}
spec:
 containers:
  - name: cli
    image: storageos/cli:${CLI_VERSION}
    command: ["/bin/sh"]
    args: ["-c", "while true; do sleep 999999; done" ]
    env:
    - name: STORAGEOS_ENDPOINTS
      value: storageos:5705
    - name: STORAGEOS_USERNAME
      value: storageos
    - name: STORAGEOS_PASSWORD
      value: storageos
END

echo -ne ".${GREEN}OK${NC}\n"


# Check if StorageOS cli is running
echo -ne "    Waiting on STORAGE${GREEN}OS${NC} CLI pod to be running..........."
# phase="$(kubectl --namespace=${STOS_NAMESPACE} describe pod cli)"
# while ! grep -q "Running" <(echo "${phase}"); do
#     sleep 10
#     phase="$(kubectl --namespace=${STOS_NAMESPACE} describe pod cli)"
# done
# echo -ne ".${GREEN}OK${NC}\n"

until phase=`kubectl --namespace=${STOS_NAMESPACE} describe pod cli |grep -q "Running" 1>/dev/null`; 
do
   spin
done
endspin
echo -ne ".${GREEN}OK${NC}\n"

echo 
echo -e "${GREEN}Your ${NC}STORAGE${GREEN}OS${NC} Cluster ${GREEN}now is up and running!"
echo
echo -e "${GREEN}Now would be a good time to deploy your first volume - see${NC}"
echo -e "${GREEN}   https://docs.storageos.com/docs/self-eval/#a-namestorageosvolumeaprovision-a-storageos-volume${NC}"
echo -e "${GREEN}for an example of how to mount a StorageOS volume in a pod${NC}"
echo
echo -e "${GREEN}Get your Free Forever Developer license - see${NC}"
echo -e "${GREEN}   https://docs.storageos.com/docs/operations/licensing/${NC}"
echo -e "${RED}A cluster can run unlicensed for 24 hours. Normal functioning of the cluster"
echo -e "${RED}can be unlocked by applying for a Free Forever Developer licence.${NC}"
echo
echo -e "${GREEN}This cluster has been set up with an etcd based on ephemeral${NC}"
echo -e "${GREEN}storage. It is suitable for evaluation purposes only - for${NC}"
echo -e "${GREEN}production usage please see our etcd installation nodes at${NC}"
echo -e "${GREEN}   https://docs.storageos.com/docs/prerequisites/etcd/${NC}"
echo 
