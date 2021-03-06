#!/bin/bash

IP=(10.106.12.111 10.106.12.112 10.106.12.113 10.106.12.114)
for x in ${IP[*]}; do ssh-copy-id -f $x; done

cd /etc/ansible
ansible-playbook -b -i hosts main.yml

cd /tmp/kubernetes-installation-template
bash start.sh

cd ~/setup-sqlbdc
bash setup-sqlbdc.sh


