#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

if [ -z $ENVIRONMENTS ] ; then
    echo "ERROR - The ENVIRONMENTS variable is empty"
    exit 1
fi

# Usage function
function usage() {
    printf "\n"
    printf "Usage:\n$0 [environment] ${USAGE_ADDITIONAL_PARAMETER}\n"
    printf "\tenvironment : ["$(arrayJoin , "${ENVIRONMENTS[@]}")"]\n"
    printf "${USAGE_ADDITIONAL_HELP}"
    printf "\n"
    exit 0
}

# Display usage if asked with -h
if [ "$1" == "-h" ] ; then
    usage
fi

# Display usage if no option
if [ -z $1 ] ; then
    usage
fi

# Display error if the environment is unknown
arrayIn ${1} "${ENVIRONMENTS[@]}"
if [ $? = 1 ] ; then
    echo "No environment $1"
    exit 1
fi

# Save the inventory
inventory=${1}
