#!/bin/bash
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

source scripts/_utils.sh
source scripts/_environment-with-lxc.sh
source scripts/_pipenv.sh
source scripts/_ansible.sh

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/cache-clean.yml -i provisioning/inventory/$inventory
exit $?
