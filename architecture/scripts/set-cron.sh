#!/bin/bash
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

USAGE_ADDITIONAL_PARAMETER="[status]"
USAGE_ADDITIONAL_HELP="\tstatus : enable/disable\n"

source scripts/_utils.sh
source scripts/_environment-with-lxc.sh
source scripts/_pipenv.sh
source scripts/_ansible.sh

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/set-cron.yml -i provisioning/inventory/$inventory -e "status=$2"
exit $?
