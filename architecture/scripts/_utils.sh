#!/bin/bash

# Array join function - join the array $2 with the glue $1
function arrayJoin {
    local IFS="$1"
    shift
    echo "$*"
}

# Array in function - check if array $2 contains element $1
function arrayIn() {
    set +e
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1 && set -e
}
