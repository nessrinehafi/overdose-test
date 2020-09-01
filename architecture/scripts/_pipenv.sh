#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

# Commands to run with pipenv if it is available
pipenv_wrap_commands=( ansible ansible-galaxy ansible-playbook )

# Sync virtual env and create pipenv command wrappers when pipenv is available
if [ -f "Pipfile.lock" ] && type pipenv &> /dev/null ; then
    PIPENV_VENV_IN_PROJECT=true pipenv sync
    for cmd in "${pipenv_wrap_commands[@]}"
    do
        eval "$(cat <<EOF
        $cmd() {
                pipenv run $cmd "\$@"
        };
EOF
)"
    done
fi
