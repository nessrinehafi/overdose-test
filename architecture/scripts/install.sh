#!/bin/bash
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

source scripts/_utils.sh
source scripts/_environment-with-lxc.sh
source scripts/_pipenv.sh
source scripts/_ansible.sh

if [ "$2" != "--force" ]; then
    echo ""
    echo "Launch the install process ?"
    echo "   WARNING: it will erase the current database if it already exists"
    read -p "   [y,n]: " confirm
    echo
    confirm=$(echo ${confirm} | tr 'A-Z' 'a-z')
    if [ "${confirm}" != "y" ]; then
        echo "  Aborded by user"
        exit 1
    fi
fi

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/install.yml -i provisioning/inventory/$inventory
exit $?
