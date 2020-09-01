#!/bin/bash
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

source scripts/_utils.sh
source scripts/_environment-with-lxc.sh
source scripts/_pipenv.sh
source scripts/_ansible.sh
if [[ $SKELETON_CRITICAL_ENVS ]]; then
    arrayIn $inventory $SKELETON_CRITICAL_ENVS
    if [ $? = 0 ] ; then
        source scripts/_check.sh
    fi
fi

# This script should have only one arg, we shift $@ from 1
shift 1

ansible-galaxy install -r provisioning/requirements.yml -p provisioning/roles -n -f
ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/provision.yml -i provisioning/inventory/$inventory "$@"
exit $?
