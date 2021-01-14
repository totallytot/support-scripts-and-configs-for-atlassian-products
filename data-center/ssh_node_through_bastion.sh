#!/bin/bash

SSH_OPTS='-o ServerAliveInterval=60 -o ServerAliveCountMax=30 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
BASTION_PUBLIC_IP=33.88.113.124
BASTION_USER=ec2-user
NODE_PRIVATE_IP=10.0.46.53
NODE_USER=ec2-user
PRIVATE_KEY_PATH=/home/ec2-user/private.pem

eval `ssh-agent -s`
ssh-add ${PRIVATE_KEY_PATH}

ssh ${SSH_OPTS} -o "proxycommand ssh -W %h:%p ${SSH_OPTS} ${BASTION_USER}@${BASTION_PUBLIC_IP}" ${NODE_USER}@${NODE_PRIVATE_IP}