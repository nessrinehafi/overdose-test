# Continuous Integration and Delivery

## Jenkins

You have to use Jenkins.

The url is: [https://ci-jenkins.vitry.intranet/](https://ci-jenkins.vitry.intranet/)

### Prepare

In order to allow Jenkins to access to the sources of your project, you must add the deploy key `CI Jenkins` on the `Deploy Keys` section of your magento git project.

If you use a separate git for the architecture, you must also add the deploy key `CI Jenkins` on the `Deploy Keys` section of your architecture git project.

You must prepare a smile integration server:

- Configuration

    - Configure the file `./architecture/provisioning/inventory/inte` with the name of the integration server.
    - Configure the file `./architecture/provisioning/inventory/group_vars/inte` with the url of the integration server.
    - If smile reconfigure is used, configure the `smilereconfigure.xml` file with the url of the integration server.

- First Deploy (manual)

    - Try to connect to the server via ssh with the root user. You **must** connect via your ssh key, not with a password.
    - Launch the command `./architecture/scripts/provision.sh`
    - Launch the command `./architecture/scripts/deploy.sh inte -f -b master`
    - Launch the command `./architecture/scripts/install.sh inte`
    - Launch the command `./architecture/scripts/setup-upgrade.sh inte`
    - Launch the command `./architecture/scripts/magento.sh inte smilereconfigure:apply-conf -e inte` (if you use smile reconfigure)
    - Launch the command `./architecture/scripts/cache-clean.sh inte`
    - Launch the command `./scripts/generate-static-di.sh inte` (if the integration use the `production` mode)

- Other Deploys (automatic)

    - Launch the command `./architecture/scripts/deploy.sh inte -s -b master`

- Then, you must add the ssh public key of Jenkins to the root user, to authorize Jenkins to provision the integration server

    ```
    getsshkey ci-jenkins > jenkins.pub
    ssh-copy-id -f -i jenkins root@myproject.vitry.intranet
    rm -f jenkins.pub
    ```

### Folder

You have to create a job folder for your project. The name of this folder:

- must be in lower-case
- must use the minus `-` separator (no space, no underscore, no point)
- must not contain the technology  (aka the magento word)

Good Example: `gibert-joseph`
Bad Example: `GibertJosephMagento`

This folder will contain 2 jobs:

- one named `magento` to launch the analysis and to create of a valid package 
- one named `deploy` to deliver the package

You will find templates for thoses 2 jobs here: https://ci-jenkins.vitry.intranet/job/magento2-template/

### Analysis Job

The analysis job `magento` can be created from the template https://ci-jenkins.vitry.intranet/job/magento2-template/job/magento/

You have to configure it:

- the specific git url to use
- the specific git branch to use
- the git group and project name (for spbuilder package usage)
- the project email

The main build steps of this job are:

- Execute Shell - `composer install --prefer-dist --no-interaction`
- Execute Shell - `./vendor/bin/spbuilder analyze --ignore-tool visualization`
- Execute Shell - `./vendor/bin/spbuilder push --job-url ${JOB_URL} --build-id ${BUILD_NUMBER}`
- Execute Shell - `./vendor/bin/spbuilder package --force-name="[gitgroup]-[gitproject]" --force-version="${BUILD_TAG}-${GIT_COMMIT}"`
- Execute Shell - `echo "${BUILD_TAG}-${GIT_COMMIT}" > ./build/dist/deploy_version`

The main post-build steps of this job are:

- Publish Checkstyle     - `build/logs/checkstyle.xml,build/logs/smileanalyser.xml`
- Publish PMD            - `build/logs/pmd.xml`
- Publish Duplicate Code - `build/logs/cpd.xml`
- Archive the artifacts  - `build/dist/*`
- Build other projetcs   - `deploy` (only if build is stable)
- Email Notification     - `project_email@smile.fr`

### Delivery Job

The delivery job `deploy` can be created from the template https://ci-jenkins.vitry.intranet/job/magento2-template/job/deploy/

You have to configure it:

- the specific git url to use
- the specific git branch to use
- keep or remove the `architecture` folder from the execute shell commands (if you have put or not the architecture in a separate project)
- the project email

The main build steps of this job are:

- Execute Shell - `rm -rf ./build/dist/*` (to clean the old packages)
- Copy artifacts - `build/dist/*` from `magento` job if stable
- Execute Shell - `./architecture[if_nedded]/scripts/provision.sh inte`
- Execute Shell - `export deploy_version=$(cat build/dist/deploy_version | xargs)`
- Execute Shell - `./architecture[if_nedded]/scripts/deploy.sh inte -p ${deploy_version} -s`
- Execute Shell - `./architecture[if_nedded]/scripts/magento.sh inte smilereconfigure:apply-conf -e inte -c y`
- Execute Shell - `./architecture[if_nedded]/scripts/cache-clean.sh inte `
  
The main post-build steps of this job are:

- Email Notification     - `project_email@smile.fr`

## Other

If you want, you can add a resume graph by following this procedure: https://git.smile.fr/dirtech/smileanalyser/blob/master/docs/howto.md#jenkins-configuration
