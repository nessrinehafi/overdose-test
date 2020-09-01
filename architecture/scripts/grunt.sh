#!/bin/bash
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

source scripts/_utils.sh
source scripts/_environment-with-lxc.sh
source scripts/_pipenv.sh
source scripts/_ansible.sh

EXTRA_VARS="grunt_params=\"${*:2}\""
ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/grunt.yml -i provisioning/inventory/$inventory -e "${EXTRA_VARS}"
exit $?
