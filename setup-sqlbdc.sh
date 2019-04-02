#!/bin/bash

#Install Kubectl utility 
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubectl-1.13.5 

if  [ ~/.kube/config ];
then
  rm -f ~/.kube/config
  scp 10.106.12.111:/etc/kubernetes/admin.conf ~/.kube/config

else
  mkdir -p ~/.kube
  scp 10.106.12.111:/etc/kubernetes/admin.conf ~/.kube/config
fi

#Deploy SQL 2019 big data cluster CTP2.3
yum install -y centos-release-scl
yum install -y rh-python36
source /opt/rh/rh-python36/enable

pip install kubernetes==8.0.1
pip install --upgrade pip

pip install -r https://private-repo.microsoft.com/python/ctp-2.4/mssqlctl/requirements.txt
#pip3 install -r https://private-repo.microsoft.com/python/ctp-2.3/mssqlctl/requirements.txt

#Setup local volume dtorage class
ansible master-1 -m command -a "kubectl apply -f ~/local-storage-provisioner.yaml"

#Install SQL 2019 BDC 
export ACCEPT_EULA=Yes
export CLUSTER_PLATFORM=kubernetes
export USE_PERSISTENT_STORAGE=true
export STORAGE_CLASS_NAME=local-storage
export CONTROLLER_USERNAME=admin
export CONTROLLER_PASSWORD=P@ssw0rd
export KNOX_PASSWORD=P@ssw0rd
export MSSQL_SA_PASSWORD=P@ssw0rd
export DOCKER_REGISTRY=private-repo.microsoft.com
export DOCKER_REPOSITORY=mssql-private-preview
export DOCKER_USERNAME=kevinwang@quantatw.com
export DOCKER_PASSWORD=dmnftnkc96dr
export DOCKER_EMAIL=kevinwang@quantatw.com
export DOCKER_PRIVATE_REGISTRY="1"

mssqlctl cluster create -n sqlctp

