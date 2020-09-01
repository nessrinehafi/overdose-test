# Script list

- __scripts/cache-clean.sh [env]__: Clean Redis, Magento and Varnish cache.
- __scripts/static-clean.sh [env]__: Empty pub/static and var/view_preprocessed on non production environment.
- __scripts/composer-requirements.sh__: Add the composer requirements for Magento 2.
- __scripts/deploy.sh [env] [-p packageVersion or -b branch or -t tag]__: Deploy the given version (or a specific tag or branch) on the target environment.
- __scripts/generate-urn-catalog.sh__: Generate the URN catalog for PHPStorm.
- __scripts/install.sh [env]__: Install Magento on LXC using the Magento setup.
- __scripts/launch-test.sh__: Launch the Magento tests on the lxc environment.
- __scripts/magento.sh [env] [magento:command] [params]__: Launch the Magento binary on the given environment. Ex: `bin/magento.sh lxc cache:flush`
- __scripts/grunt.sh [env] [task:themename]__: Launch the Grunt command on the given environment. Ex: `bin/grunt.sh lxc exec:themename`
- __scripts/permissions.sh [env]__: Restore the file permissions on the given environment.
- __scripts/provision.sh [env] [ansible-playbook native args]__: Install all needed components and configure them. With ansible args you can for exemple use --limit and/or --tags options.
- __scripts/set-cron.sh [env] [enable|disable]__: Enable or Disable the magento cron.
- __scripts/set-maintenance.sh [env] [enable|disable]__: Add or remove the maintenance flag.
- __scripts/setup-upgrade.sh [env]__: Launch the Magento setup upgrade on the given environment.

# Vars used by scripts

- SKELETON_CRITICAL_ENVS: List of envs with prompt confirmation needed
- SKELETON_NEED_LOCAL_HOSTSFILE_ENVS: List of envs with embeded known_hosts file needed

These vars can be overridden in skeleton.conf file (see sample file).
