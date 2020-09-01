#!/bin/bash
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

inventory="lxc"
source scripts/_utils.sh
source scripts/_pipenv.sh
source scripts/_ansible.sh

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/launch-test.yml -i provisioning/inventory/$inventory
exit $?
