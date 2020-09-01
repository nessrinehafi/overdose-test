#!/bin/bash

ANSIBLE_VERSION=$(ansible --version | grep "ansible" | cut -d " " -f 2);
ERROR=""

if [ "${ANSIBLE_VERSION}" \< "2.5.0.0" ]; then
    ERROR="upgrade"
fi

if [ "${ANSIBLE_VERSION}" \> "2.5.9.9" ]; then
    ERROR="downgrade"
fi

if [ ! -z "${ERROR}" ]; then
    echo ""
    echo "ERROR:"
    echo "  You must ${ERROR} your Ansible version."
    echo "  This skeleton is only compatible with Ansible 2.5.x."
    echo "  Your actual version is [${ANSIBLE_VERSION}]."
    echo "  You can install 'pipenv' to let the skeleton manage its dependencies."
    echo ""
    exit 1
fi

ANSIBLE_SSH_ARGS=""
SKELETON_CRITICAL_ENVS="prod"
SKELETON_NEED_LOCAL_HOSTSFILE_ENVS="inte staging"

if [ -f ./skeleton.conf ]; then
    source skeleton.conf
fi

arrayIn $inventory $SKELETON_NEED_LOCAL_HOSTSFILE_ENVS
USE_HOSTFILE=$?
if [ $USE_HOSTFILE == 0 ] && [ -f ./known_hosts ]; then
    ANSIBLE_SSH_ARGS="$ANSIBLE_SSH_ARGS -o UserKnownHostsFile=./known_hosts"
fi
