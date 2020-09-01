# Changelog

## [4.4.3] - 2020-01-16
[4.4.3]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.4.2...4.4.3

- Upgrade ansible-basicserver role to version 2.0.0

## [4.4.2] - 2020-01-06
[4.4.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.4.1...4.4.2

- Upgrade ansible-mysql-server role to version 1.0.8

## [4.4.1] - 2019-12-02
[4.4.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.4.0...4.4.1

- Compatibility with Debian 10
- Add graphql configuration in Varnish template

## [4.4.0] - 2019-10-23
[4.4.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.3.7...4.4.0

- Drop compatibility with Ansible 2.4.x
- More coherent error messages during project initialization
- Update each role to latest version available
- Update npm to version from 10.16.0 to 10.16.3
- Update mysql from 5.6 to 5.7
- Update elasticsearch from 6.8.1 to 6.8.3
- Move es_java_version variable to distro-vars

## [4.3.7] - 2019-10-09
[4.3.7]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.3.6...4.3.7

- Compatibility with Magento 2.3.3 and 2.2.10
- Composer: update PHP version in `platform.config` parameter
- Enable json/svg gzip compression on Apache
- Update mysql-server ansible role (Update GPG key for Percona)

## [4.3.6] - 2019-07-22
[4.3.6]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.3.5...4.3.6

- Fix incompatibility with `--no-dev` composer option
- Upgrade elasticsearch to 6.8.1
- Upgrade nodejs to 10.16.0

## [4.3.5] - 2019-07-03
[4.3.5]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.3.4...4.3.5

- Compatibility with Magento 2.1.18, 2.2.9, 2.3.2
- New coding standard (extends magento-coding-standard)
- Move bin vendor commands from bin/ to vendor/bin/

## [4.3.4] - 2019-03-27
[4.3.4]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.3.3...4.3.4

- Add compatibility with 2.1.17, 2.2.8, 2.3.1
- Update the manual install documentation

## [4.3.3] - 2019-03-07
[4.3.3]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.3.2...4.3.3

- Fix php service name in `sudo_allowed_root_commands` config param

## [4.3.2] - 2019-02-26
[4.3.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.3.1...4.3.2

- PHP 7.2 support for CentOS-7
- Compatibility with elasticsearch 5.x and 6.x
- Default elasticsearch version is now 6.6.1
- Update logrotate configuration in order to fix file permissions
- Add `compiled_config` and `vertex` cache types in env.php.j2 template
- Add Magento 2.3 changes to the Varnish VCL template

## [4.3.1] - 2019-01-15
[4.3.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.3.0...4.3.1

- Use the CodeSniffer ruleset `smile/php-codesniffer-rules-magento-2`

## [4.3.0] - 2018-12-13
[4.3.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.2.1...4.3.0

- New distro-vars file structure, system requirements now depend on the version of Magento
- Use PHP 7.1 when Magento >= 2.1 with CentOS 7 and RedHat 7
- Install Smile_Patch by default when Magento >= 2.3.0

## [4.2.1] - 2018-12-06
[4.2.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.2.0...4.2.1

- Optimize composer installation (Smile tools/modules installed with a single command)
- Let `pipenv` install virtualenv in `architecture/.venv` directory instead of `~/.local/share/virtualenvs`
- Fix fatal error when running the generate-catalog-urn script

## [4.2.0] - 2018-11-26
[4.2.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.13...4.2.0

- Compatibility with Magento 2.1.16, 2.2.7, 2.3.0
- Default lxc template for Magento 2.3 is `bionic` instead of `stretch`
- php-mcrypt library removed for Magento 2.3
- Automated Ansible installation with pipenv (optional)
- Rename version scripts (2_00 -> 2_0, 2_01 -> 2_1, 2_02 -> 2_2)
- Remove deprecation warnings when using Ansible 2.5
- Fix 2.2.6 re-install of existing project
- Update Magento Cloud template to latest version
- Add new custom config/scripting file skeleton.conf
- Add documentation in ansible.cfg
- Add automatic exit if part of bash script fails
- Add prompt confirmation for critical actions
- Fix typos in the init script
- Fix loop index in env.php templates ('http_cache_hosts' section)
- Add alternative Ansible and Python dependencies installation method
- Separate webservers (apache/php-fpm) and proxyservers (varnish/nginx)
- Make nginx installation optional (eg. if you already have an SSL offloader)
- Add CDN option to automatically configure varnish behind a CDN for media
- Add handling of PROXY protocol from end-to-end (EXPERIMENTAL)
- Add handling of HTTP2 protocol on the highest level of stack (Nginx)
- Add option for newrelic installation
- Add dynamic varnish backends feature to work with multiple webservers as loadbalancer
- Add prompt colors per environment
- Add logrotate on magento log files
- Add handling of ansible-playbook native args to `provision.sh` script
- Use latest roles versions. Ansible 2.1 is not compatible anymore! Use at least 2.4!
- Remove debian 8 template file
- Update nodejs to version 10.13.0
- Add var for smile_ssh_key_provider (default ldapkey, possible for now s3key)
- Add vars to handle NFS shared files and folders
- Never store REDIS cache on disk, keep only sessions persistent

**COMPATIBILITY BREAK**:

  Dropped support of Debian 8.
  Dropped support of Ansible 2.1.
  The skeleton is now only compatible with Ansible 2.4 and 2.5.

## [4.1.13] - 2018-10-16
[4.1.13]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.12...4.1.13

- Add compatibility with Magento 2.2.6 and 2.1.15
- Fix `magento_http_cache_hosts` value (varnish is on the port 81)

## [4.1.12] - 2018-06-28
[4.1.12]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.11...4.1.12

- Better compatibility with Magento 2.2.5

## [4.1.11] - 2018-06-28
[4.1.11]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.10...4.1.11

- Add compatibility with Magento 2.2.5

## [4.1.10] - 2018-06-21
[4.1.10]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.9...4.1.10

- Added a prompt to warn about project names exceeding 16 characters

## [4.1.9] - 2018-06-18
[4.1.9]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.8...4.1.9

- Allow using Ansible 2.5.x
- Update composer platform requirements

## [4.1.8] - 2018-05-25
[4.1.8]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.7...4.1.8

- Add compatibility with 2.1.13 and 2.2.4
- Add pipeline jenkinsfile-install to install the integration
- Update pipeline jenkinsfile format
- Fix issue #38 - add parameter `magento_cron_every_minutes`
- Fix mysql memory usage on INTE and LXC
- Fix use production mode on integration, to be iso with the prod env

## [4.1.7] - 2018-03-05
[4.1.7]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.6...4.1.7

- Update ansible roles versions

## [4.1.6] - 2018-03-05
[4.1.6]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.5...4.1.6

- Add exit code on each scripts
- Add Centos7 with PHP7.0 Compatibility
- Add compatibility with 2.0.18, 2.1.12 and 2.2.3

## [4.1.5] - 2018-02-28
[4.1.5]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.4...4.1.5

- Update better ansible script for enable/disable magento cron
- Fix apache virtualhost - bad mime type on html files in static and media folder

## [4.1.4] - 2018-01-15
[4.1.4]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.3...4.1.4

- Add implement ssl.enabled for nginx vhost
- Add on/off of `X-Forwarded-Proto` and `X-Forwarded-For` override for nginx vhost
- Update manual provisioning doc

## [4.1.3] - 2017-12-14
[4.1.3]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.2...4.1.3

- Add compatibility with 2.1.11 and 2.2.2

## [4.1.2] - 2017-12-12
[4.1.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.1...4.1.2

- Add Ansible 2.4 compatibility
- Update test scripts
- Fix the `magento_maintenance_allowed_ips` parameter on the `lxc` group var, in order to test the maintenance mode on lxc environment
- Fix the automatic package generation during deploy process
- Fix some task names for better understanding of some tasks
- Fix static content generation on developer environment for magento 2.2
- Fix git ignore file for grunt usage
- Fix disable Mysql Bin Log on LXC, INTE, and STAGING environement. Add new parameter `magento_mysql_use_binlog`

**IMPORTANT POINT**:

  All skeleton versions are compatible with ansible 2.1, but if you work only on projects with recent skeletons, you can update Ansible with the following command:

```bash
sudo pip install ansible==2.4.2.0
```

## [4.1.1] - 2017-12-04
[4.1.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.1.0...4.1.1

- X-Forwarded-For security issue fixed. Nginx listen to 443 and 80 ports.
- Fix error during init of EE, add bcmath php extension to composer config

## [4.1.0] - 2017-11-13
[4.1.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/4.0.0...4.1.0

- Better deploy process (using a temporary redis database to avoid conflict with the curren running release)
- Remove app/etc/config.php from shared folder (Magento need to commit this file)
- Add compatibility with 2.0.17, 2.1.10, and 2.2.1
- Finish Magento 2.2 compatibility
  - Better `env.php` file generation
  - Update the grunt documentation
  - Add new versions 3.x.x of smile modules

**COMPATIBILITY BREAK**:

  Be careful, the parameter `magento_cache_database_for_run` was replaced by `magento_cache_database_for_run` and `magento_cache_database_for_setup`.
  Now, it uses a temporary redis database during deploy  

  Be careful, the config.php file must be commited. You must:

- Upgrading the .gitignore magento file from the skeleton
- Commit your app/etc/config.php file on your repo

## [4.0.0] - 2017-10-12
[4.0.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.11.0...4.0.0

- Prepare Magento 2.2.0 compatibility
  - Add new available version
  - Add new `generated` folder management
  - Update the apache virtualhost template
  - Update the varnish vcl template
  - Update the .gitignore file.
- Add needed composer config platform requirements (no need of --ignore-platform-reqs anymore)
- Disable the Magento native profiler, to use the Smile Debug Toolbar instead
- Add scripts to test 2.0, 2.1, and 2.2 versions
- Better init script

## [3.11.0] - 2017-09-21
[3.11.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.10.5...3.11.0

- Change the default LXC template use: stretch (PHP7)
- Add smile debug toolbar as require dev

**COMPATIBILITY BREAK**:

  Be careful to keep your current lxcfile template value when updating

## [3.10.5] - 2017-09-18
[3.10.5]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.10.4...3.10.5

- Add Magento 2.1.9 compatibility
- Fix bug on redis role - update the used role version
- Fix pipeline jenkins files

## [3.10.4] - 2017-09-11
[3.10.4]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.10.3...3.10.4

- Add new parameter magento_backend_redirect_host to choose the front server that must provide the BO
- Fix bug on apache role - update the used role version

## [3.10.3] - 2017-09-04
[3.10.3]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.10.2...3.10.3

- Add message when file is ansible managed
- Fix inventory group_var definition
- Fix innodb_buffer_pool_size value on LXC and INTE
- Fix mysql flavor on stretch, now it uses Percona instead of MariaDB
- Fix bug on varnish role - update the used role version

## [3.10.2] - 2017-08-17
[3.10.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.10.1...3.10.2

- Add Magento 2.1.8 compatibility
- Add usage of fixed version for Ansible galaxy requirements

## [3.10.1] - 2017-06-07
[3.10.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.10.0...3.10.1

- Add Magento 2.1.7 compatibility
- Add known_hosts file in ansible config
- Fix issue #25 - provide know_hosts to the Ansible configuration
- Fix issue #26 - add dynamic environment list detection

**WARNING**:

- You must add all your servers keys (except lxc one) in the `architecture/known_hosts`, and commit this file.
- The _environment.sh files have changed

## [3.10.0] - 2017-05-29
[3.10.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.9.3...3.10.0

- Add RedHat7 with PHP7.0 Compatibility
- Add documentation on how apply magento patches
- Fix issue #24 - add nodejs_version variable on Debian-8 environment config file

## [3.9.3] - 2017-05-12
[3.9.3]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.9.2...3.9.3

- Add Jenkins Continuous Integration and Delivery doc
- Fix cached static files must be shared and put on the NFS for multi server configuration
- Fix cached static files must be cleaned by the clean-cache ansible script
- Fix magento command setup:static-content:deploy must be executed separately for each language
- Fix magento command cache:clean must be executed only on the main webserver
- Fix issue #23 - add nodejs_version variable on Debian-9 environment config file to install a nodejs version packaged with npm
- Fix issue #12 - add delivery_user in adm and varnish groups

**WARNING**:

  Be careful if you have multi fronts, you must share the folder `pub/static/_cache` between them.

## [3.9.2] - 2017-04-26
[3.9.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.9.1...3.9.2

- Add Magento 2.1.6 compatibility
- Add `magento_secure_frontend` and `magento_secure_backend` variables
- Add setup upgrade parameters for "default" Magento mode
- Fix pipeline jenkinsFile
- Fix init script when installing smile modules
- Fix issue #21 - disable /swagger access by default

## [3.9.1] - 2017-04-03
[3.9.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.9.0...3.9.1

- Add new script `set-cron.sh` to enable or disable magento cron
- Add new module `smile/module-varnish`
- Add new dev module `smile/magento2-library-testframework`
- Fix varnish vcl: normalize the query arguments
- Fix varnish vcl: add front hostname to the debug headers
- Fix varnish vcl: align varnish template to the Magento core one in page cache module

## [3.9.0] - 2017-03-15
[3.9.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.8.1...3.9.0

- Fix merge all the varnish files (all, preprod, prod) in one single file, with new parameter `varnish_enable_protection`
- Fix issue #17 - better test on the `magento_php_mode` parameter
- Fix issue #16 - add alias on nginx vhost, add alias on `/etc/hosts` of the webservers, add documentation
- Fix issue #15 - better usage of the redis persistence setting `redis_setting_save`, reduce the number of database `redis_setting_databases`
- Fix issue #14 - do not duplicate varnish cache for the media and static files

**COMPATIBILITY BREAK**:

  Be careful if you have specific VCL template files per env, now they are merged! You must do the same.

## [3.8.1] - 2017-03-09
[3.8.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.8.0...3.8.1

- Add new magento parameter `magento_server_alias`
- Add new varnish parameters `varnish_backend_connect_timeout` and `varnish_backend_first_byte_timeout`
- Add scripts (in `tests` folder) to test the skeleton on jessie, stretch, and xenial
- Fix maintenance mode duration during deploy process - now Statics and DI are generated before the maintenance mode activation
- Fix https usage for BO (nginx website has an error)
- Fix when a symlink is used as shared folder

## [3.8.0] - 2017-03-07
[3.8.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.7.4...3.8.0

- Add Debian 9 (Stretch) Compatibility
- Add Ubuntu Server 16.04 (Xenial) Compatibility
- Add manual deploy procedure
- Add Magento 2.1.5 and 2.0.13 compatibility
- Add test on the Ansible version
- Fix use php module names instead of php package names
- Fix init script was too slow when adding smile modules and sample datas
- Fix deploy script, the cron was enabled before the symlink switch
- Fix restore magento cloud default rules for static folder

## [3.7.4] - 2017-02-14
[3.7.4]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.7.3...3.7.4

- Fix varnish cache depends on browser
- Fix BO that must only works on front1
- Fix bug on init script for magento cloud projects

## [3.7.3] - 2017-01-30
[3.7.3]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.7.2...3.7.3

- Adding Unit Test documentation
- Adding Magento 2.1.4 and 2.0.12

## [3.7.2] - 2017-01-30
[3.7.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.7.1...3.7.2

- Add Ansible log documentation
- Add new smile modules to the init script
- Fix module creation documentation
- Fix varnish vcl to cache HTTP and HTTPS page versions separately

## [3.7.1] - 2017-01-26
[3.7.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.7.0...3.7.1

- Fix OpCache flush after deploy new release, see [OpCache bug](http://codinghobo.com/opcache-and-symlink-based-deployments/)

**WARNING**:

  You must restart the provision script on all the environments to add the good sudo rights on the smile user

## [3.7.0] - 2017-01-24
[3.7.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.6.2...3.7.0

- Fix error when launch the static file generation, due to multi-jobs usage
- Fix better confirm question in install script
- Fix authorize minus in project name
- Fix allowed commands for sudoers
- Fix better documentation about elasticsearch when deploying on a production environment
- Fix better doc for grunt usage + better gitignore file

**COMPATIBILITY BREAK**:

  You must:

- Delete your `dev/tools/grunt/configs/themes.js` file
- Commit the deleted file on git
- Update the `.gitignore` file from the skeleton
- Remove your `./vendor` folder and execute `composer install` to restore the `themes.js` original file
- Follow the [Grunt Documentation](./architecture/docs/grunt.md) to add your theme to the grunt configuration
- Commit all the files


## [3.6.2] - 2017-01-20
[3.6.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.6.1...3.6.2

- Add new init option: install smile module or not
- Add parameters on init script
- Fix bug on init script when the script was launch twice at the same time
- Fix bug on init script when asking for version < 2.1.0
- Fix better sample data install process durint init script
- Fix better git ignore file for grunt usage + better doc
- Fix automatic package generation error during deploy process

## [3.6.1] - 2017-01-12
[3.6.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.6.0...3.6.1

- Add Magento 2.1.3 compatibility

## [3.6.0] - 2017-01-10
[3.6.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.5.3...3.6.0

- Add update varnish version from 4.0 to 4.1

**COMPATIBILITY BREAK**:

  You must:

- Uninstall manually varnish: apt-get purge -y varnish
- Remove the varnish files: rm -rf /etc/varnish  /var/lib/varnish /etc/systemd/system/varnish.service /etc/default/varnish*
- Remove the varnish apt file: rm -f /etc/apt/sources.list.d/varnish.list
- Execute the provisionning script


## [3.5.3] - 2017-01-09
[3.5.3]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.5.2...3.5.3

- Add protection on project name during init script
- Fix update for new versions of SpBuilder and SmileAnalyser
- Fix update pipeline jenkins files
- Fix better doc

## [3.5.2] - 2017-01-03
[3.5.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.5.1...3.5.2

- Add separate cache and session in 2 redis instances
- Add php fpm support with pools. You can select the php mode (apache2/fpm) with the magento_php_mode parameter
- Add new script to launch unit/static/integration tests
- Fix "basic server" ansible role was launch too many times

**COMPATIBILITY BREAK**:

  You must:

- Uninstall manually redis: apt-get purge -y redis-server
- Uninstall manually php for apache: apt-get purge -y libapache2-mod-php5
- Remove the redis files: rm -rf /etc/redis /var/lib/redis
- Execute the provisionning script

## [3.5.1] - 2016-12-19
[3.5.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.5.0...3.5.1

- Add use Smile Repository mirror instead of Magento official Repository
- Add can chose magento version during init script
- Fix update the doc for cloud project

## [3.5.0] - 2016-12-19
[3.5.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.4.1...3.5.0

- Add prepare Magento Cloud support (beta version, not finished)

## [3.4.1] - 2016-12-07
[3.4.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.4.0...3.4.1

- Add specific backend url for prod
- Add specific varnich vcl file for prod
- Add new variable varnish_client to specify a list of ip to authorize
- Add new nginx variables to specify the ssl certificate to use
- Add remoteip apache2 module with smile hosting conf file
- Add readline php module
- Add smile hosting combined log (use remoteip apache2 module) for access log
- Add unified varnish vcl files
- Add elastic search plugin lmenezes/elasticsearch-kopf (not in prod env)
- Fix use EUR as default currency
- Fix typo errors
- Fix bug when provisioning for the first time a new env with separate front/db
- Fix bug on php version when using composer during init script

## [3.4.0] - 2016-12-01
[3.4.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.3.2...3.4.0

- Add parameters log in the init.sh file
- Add use verbose mode for magento install script, to see the errors
- Add specific mysql password for prod environment
- Add protection when using the root user to init a new project
- Add package generation on deploy if not found
- Add new module smile/module-indexer in the init script
- Fix better prod/preprod config for elasticsearch
- Fix better varnish vcl file (unset some headers)
- Fix better magento gitignore file
- Fix better documentation

## [3.3.2] - 2016-11-15
[3.3.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.3.1...3.3.2

- Add documentation on Developer ToolBar
- Add support for jenkins pipeline project (alpha version)
- Fix documentation for environment with separate servers
- Fix bug on URN catalog generation
- Fix Change elasticsearch version format

## [3.3.1] - 2016-09-28
[3.3.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.3.0...3.3.1

- Fix Redis session storage configuration

## [3.3.0] - 2016-09-26
[3.3.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.2.3...3.3.0

- Add app/etc/config.php in shared folder
- Fix cron execution during install execution

**COMPATIBILITY BREAK**:

  You must:

- Erase your app/etc/config.php file manually
- Commit it on your repo
- Upgrading the .gitignore magento file from the skeleton

## [3.2.3] - 2016-09-23
[3.2.3]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.2.2...3.2.3

- Add cache prefix to Magento configuration
- Add specific vcl for preprod, with basic auth
- Fix better inventory structure
- Fix better generic configuration
- Fix project_name replaced in deploy_release_path param
- Fix Update searchservers configuration to prevent mistake when updating a project skeleton

## [3.2.2] - 2016-09-14
[3.2.2]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.2.1...3.2.2

- Fix upgrade elastic-search from 2.2 to 2.4
- Fix remove elastic-search head plugin on production env
- Fix grunt.sh and magento.sh scripts must be executed only on the main webserver
- Fix mysql configuration "log_bin_trust_function_creators" needed by magento triggers
- Fix SmileAnalyser documentation link correction

## [3.2.1] - 2016-09-06
[3.2.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.2.0...3.2.1

- Fix better elastic-search configuration
- Fix better doc for delivery
- Fix smile user usage during provision script

## [3.2.0] - 2016-09-02
[3.2.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.1.0...3.2.0

- Fix better usage of smile user

## [3.1.0] - 2016-08-05
[3.1.0]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.0.1...3.1.0

- Add elastic-search support

## [3.0.1] - 2016-08-04
[3.0.1]: https://git.smile.fr/magento2/architecture-skeleton/compare/3.0.0...3.0.1

- Fix better delivery user management
- Fix bad inventory declaration for envs
- Fix bug on the varnish role (it was not enabled at server reboot)

## [3.0.0] - 2016-08-03
[3.0.0]: https://git.smile.fr/magento2/architecture-skeleton/tree/3.0.0

- Add use nginx for ssl
- Add separate the architecture and magento
- Add prepare prepod and prod configuration
- Add hosting aliases mydb, myredis, myfront1, ...
- Fix remove the src folder
- Fix better deploy script
- Fix better mysql configuration
- Fix better varnish configuration
- Fix update the documentation

## [2.0.1] - 2016-07-13

- Fix better documentation
- Fix redis session configuration

## [2.0.0] - 2016-06-27

- Add compatibility with Magento 2.1

**COMPATIBILITY BREAK**:

  Now you have 2 composer.json and 2 composer.lock files:
  In root folder, for Smile tools.
  In src folder, for Magento 2. This one must be used from the host.

## [1.3.4] - 2016-06-21

- Add grunt script to run grunt frontend tasks
- Add static cleaning script to empty static files on development mode only
- Add apache configuration for production mode
- Fix better php memory limit
- Fix better setup-upgrade script (display the result of setup upgrade)
- Fix better scripts for environment selection
- Fix Smile modules requirements changed
- Fix update documentation

## [1.3.3] - 2016-05-19

- Add better configuration for php opcache
- Add protection on composer-requirement.yml
- Add protection on install.yml
- Fix better .gitignore file

## [1.3.2] - 2016-05-12

- Fix shared folder list
- Fix deploy yml script

## [1.3.1] - 2016-05-12

- Add static file cleaning for dev environment on cache clean
- Add var/view_preprocessed to static content cleaning
- Add jenkins on autorized users for delivery on inte environment

## [1.3.0] - 2016-05-04

- Add staging environment
- Fix better deploy script
- Fix better parameters

## [1.2.3] - 2016-05-03

- Add new script composer-install.sh
- Fix bad parameter on magento.sh script
- Fix regroup specific parameters of the project
- Fix update the docs

## [1.2.2] - 2016-04-28

- Add use ansible-genericservice role
- Add use ansible-npm role if needed
- Add use ansible-maildev role if needed
- Add parameter magento_install_maildev to install maildev (true on LXC)
- Add parameter magento_install_grunt to install grunt-cli (true on LXC)

## [1.2.1] - 2016-04-27

- Fix smile analyser version
- Fix spbuilder version

## [1.2.0] - 2016-04-26

- Add ssl support
- Add language parameter to installation script
- Add XDebug support for LXC
- Fix  Webserver user and group parameters changed
- Fix Redis clean cache does not purge sessions
- Fix install script when config.php file already exist

## [1.1.10] - 2016-04-25

- Add documentation: Creating Magento 2 module for Smile
- Fix composer dependencies between magento and spbuilder

## [1.1.9] - 2016-04-19

- Add new config for basic server for delivery_users
- Add use the current smile user that launch the create project
- Fix remove the fixed version for ansible basic-server role
- Fix temporary fix for composer dependencies

## [1.1.8] - 2016-04-11

- Add script composer-update.sh
- Fix better ansible conf for basic server: add delivery user and install sudoers

## [1.1.7] - 2016-04-04

- Fix dependency on symfony/finder (magento 2.0.4 compatibility pb)
- Fix composer-requirements.yml file to be able to reexecute it

## [1.1.6] - 2016-03-30

- Fix better requirement on symfony console version

## [1.1.5] - 2016-03-24

- Fix better detection of Smile Setup during setup-upgrade script

## [1.1.4] - 2016-03-24

- Fix better .gitignore for SmileAnalyser
- Fix better requirement on symfony console version

## [1.1.3] - 2016-03-17

- Add separate the cdeploy and the provisioning

## [1.1.2] - 2016-03-16

- Add Smile Core and Smile Reconfigure modules
- Fix smile module names

## [1.1.1] - 2016-03-14

- Fix bug on the first install of magento: the encrypt key was not set

## [1.1.0] - 2016-03-14

- Add create new script composer-requirements.sh to separate the "Install Src" part and the "Install DB" part
- Add update the app/etc/env.php file when provisioning a environnement
- Add create the app/etc/env.php file when installing a environnement
- Fix rename magento_display_errors => magento_php_display_errors
- Fix better configuration on magento_php_display_errors
- Fix add configuration magento_php_error_reporting

## 1.0.0 - 2016-03-07

- First version of the Skeleton
