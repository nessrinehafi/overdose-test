#!/bin/bash
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

USAGE_ADDITIONAL_PARAMETER="[-p PreGeneratedPackage] [-b VCSBranch] [-t VCSTag] [-s] [-f] [-h]"
USAGE_ADDITIONAL_HELP="\t-p : Specify a generated package version to deliver\n\t-b : Specify a VCS branch to deliver\n\t-t : Specify a VCS tag to deliver\n\t-f : First Install (database not yet initialized)\n\t-s : Launch Setup Upgrade\n\t-h : this help\n"

DEPLOY_NAME="";
EXTRA_VARS=""
BUILD_EXTRA_VARS=""

source scripts/_utils.sh
source scripts/_environment-without-lxc.sh
source scripts/_pipenv.sh
source scripts/_ansible.sh

if [ -z $2 ]
  then usage
fi

if [[ $SKELETON_CRITICAL_ENVS ]]; then
    arrayIn $inventory $SKELETON_CRITICAL_ENVS
    if [ $? = 0 ] ; then
        source scripts/_check.sh
    fi
fi

# Retreive params
OPTIND=2
while getopts "p:b:t:sfh" VARNAME; do
    case $VARNAME in
        h)
            usage
            ;;
        p)
            PACKAGE="$OPTARG"
            ;;
        b)
            BRANCH="$OPTARG"
            ;;
        t)
            TAG="$OPTARG"
            ;;
        f)
            FIRST_INSTALL="Y"
            ;;
        s)
            SETUP_UPGRADE="Y"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage
            ;;
    esac
done

# Check that options are valid
if [ -z "${PACKAGE}" ] && [ -z "${BRANCH}" ] && [ -z "${TAG}" ]; then
    echo "ERROR: You must precise a package or a branch or a tag to deliver"
    exit 1;
fi

if [ "${BRANCH}" != "" ] && [ "${TAG}" != "" ]; then
    echo "ERROR: You cannot use -b and -t together"
    exit 1;
fi

if [ "${FIRST_INSTALL}" == "Y" ] && [ "${SETUP_UPGRADE}" == "Y" ]; then
    echo "ERROR: You can not use -f and -s together"
    exit 1;
fi

# Prepare vars to pass to playbooks
if [ "${BRANCH}" != "" ]; then
    DEPLOY_NAME="${BRANCH}-`date +%Y%m%d%H%M`"

    echo "Create new package from branch [${BRANCH}]"
    cd ..
    vendor/bin/spbuilder package -n --force-version="${DEPLOY_NAME}" --force-branch="${BRANCH}"
    cd -
    echo ""
elif [ "${TAG}" != "" ]; then
    DEPLOY_NAME="${TAG}"

    echo "Create new package from tag [${TAG}]"
    cd ..
    vendor/bin/spbuilder package -n --force-version="${DEPLOY_NAME}" --force-tag="${TAG}"
    cd -
    echo ""
else
    DEPLOY_NAME="${PACKAGE}"
fi

if [ "${FIRST_INSTALL}" == "Y" ]; then
    EXTRA_VARS="${EXTRA_VARS} first_install=Y"
fi

if [ "${SETUP_UPGRADE}" == "Y" ]; then
    EXTRA_VARS="${EXTRA_VARS} setup_upgrade=Y"
fi

EXTRA_VARS="deploy_version=${DEPLOY_NAME} ${EXTRA_VARS}"

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/deploy.yml -i provisioning/inventory/$inventory -e "${EXTRA_VARS}"
exit $?
