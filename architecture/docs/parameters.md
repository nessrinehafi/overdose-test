# Ansible parameter list

## Global parameters

Variable | Default value |Description
---------|---------------|--------------
magento_project_name | pagebuilder | Project name, initialised with composer create-project
magento_version | 2.3.3 | Magento version, must be changed at every magento update
magento_delivery_path | /var/www/{{ magento_project_name }} | Project delivery path (only for delivered environment)
magento_project_path | {{ magento_delivery_path }} | Project sources path on the remote host
magento_source_path | {{ magento_project_path }} | Magento sources path on the remote host
magento_hostname | www.{{ magento_project_name }}.com | Magento principal hostname
magento_server_alias | \[\] | Magento alias hostnames
magento_project_user | smile | Delivery user on the remote host
magento_project_group | root | Delivery group on the remote host
magento_delivery_groups | adm,varnishlog | Groups in which we add the user on the remote host (comma separated)
magento_webserver_user | www-data | Apache user
magento_webserver_group | www-data | Apache group
magento_mode | production | Magento mode (developer/production/default)
magento_use_cdn | false | Make some changes in confs if you use a CDN for static resources
magento_stack_use_proxy_proto | false | Enable a full stack with PROXY protocol (experimental)
magento_stack_use_nginx_offloader | true | Enable Nginx to offload SSL (useless beind an HTTPS load blancer)
magento_profiler | Off | Enable the Magento profiler
magento_profiler_type | html | Profileur type (html/csv)
magento_php_display_errors | Off | Variable for PHP display_errors parameter  
magento_php_error_reporting | E_ALL | Variable for PHP error_reporting parameter
magento_admin_firstname | {{ magento_project_name }} | Magento admin user firstname
magento_admin_lastname | {{ magento_project_name }} | Magento admin user lastname
magento_admin_email | {{ magento_project_name }}@smile.fr | Magento admin user email
magento_admin_user | admin |  Magento admin user login
magento_admin_password | magent0 |  Magento admin user password
magento_backend_frontname | admin |  Magento backend frontname in URL
magento_backend_redirect_host | myfront1 | Host that contain the BO
magento_secure_frontend | 0 |  Use SSL for storefront (1 - use, 0 - do not use)
magento_secure_backend | 0 |  Use SSL for Magento Admin (1 - use, 0 - do not use)
magento_db_host | mydb | Magento database hostname
magento_db_name | {{ magento_project_name }} | Magento database name
magento_db_table_prefix | | Magento database table prefix
magento_db_user | {{ magento_project_name }} | Magento database user
magento_db_password | {{ magento_project_name }} | Magento database password
magento_install_date | | Magento installation date __to be provided after Magento install__
magento_crypt_key | | Magento installation cript key __to be provided after Magento install__
magento_use_rewrites | | Magento installation parameter --use-rewrites
magento_currency | USD | Magento installation parameter --currency
magento_language | en_US | Magento installation parameter --language
magento_timezone | Europe/Paris | Magento installation parameter --timezone
magento_cronjob | {{ php_path }} {{ magento_source_path }}/bin/magento cron:run >> {{ magento_source_path }}/var/log/magento.cron.log | The line that will be added to the crontab
magento_cron_every_minutes | 1 | Execute the magento cron every X minutes
magento_php_mode | fpm | Used php mode: apache2 or fpm
magento_cache_id_prefix | {{ magento_project_name }}_ | Magento prefix cache id
magento_cache_host | myredis | Host for Magento internal cache (Redis by default)
magento_cache_port | 6379 | Port for Magento internal cache
magento_cache_database_for_run | 0 | Redis Database number for Magento internal cache
magento_cache_database_for_setup | 1 | Redis Database number for Magento internal cache during setup upgrade script
magento_cache_session_host | myredis | Host for Magento session storage (redis)
magento_cache_session_port | 6380 | Port for Magento session storage (redis)
magento_cache_session_database | 0 | Database number for Magento session storage (redis)
magento_http_cache_hosts | *following parameters* | List of proxy cache servers
magento_http_cache_hosts.hosts | myfront1 | Proxy cache host (Varnish by default)
magento_http_cache_hosts.port | 80 | Proxy cache port
magento_deploy_di_logs_path | /tmp/magento_deploy_di.log | Path for di generation logs
magento_deploy_static_content_logs_path | /tmp/magento_deploy_static_content.log | Path for static content generation logs
magento_maintenance_allowed_ips | [] | Allowed IP to access Magento during maintenance
magento_install_grunt | false | Install grunt for devs (only on lxc)
magento_install_maildev | false | Install maildev, accessible on http://xxxx.lxc:1080/
magento_install_newrelic | false | Install newrelic agent (on webservers only)
magento_enable_swagger | false | If true, enables /swagger access
magento_ssl_certificate_key_file | /etc/ssl/private/ssl-cert-snakeoil.key | ssl certificate to use. must be overridden for prod env
magento_ssl_certificate_file | /etc/ssl/certs/ssl-cert-snakeoil.pem | ssl certificate to use. must be overridden for prod env
magento_varnish_enable_protection | none | To enable IP http basic protection. The values are `none`, `all`, `bo-only`
magento_varnish_basic_auth | XXXXXXXXXXXXXXXXXXXXXXX | The http basic protection to use, if varnish_enable_protection is different from `none`
magento_varnish_backend_type | alone |  [alone, dynamic, webservers] If alone, une only one webserver as backend. If dynamic, allow varnish to have multiple backends behind one domain with multiple A records (ex: AWS ELB + autoscaling group). If webservers, varnish will load balance traffic using all "webservers" as backend.
magento_mysql_use_binlog | 1 | Enable the Mysql Bin log
delivery_authorized_smile_users | initial user | List of available smile users for deploy
delivery_authorized_users | delivery_authorized_smile_users | List of available users for deploy
delivery_authorized_extra_keys | empty | List of available extra keys for deploy
deploy_release_path | ../build/dist/smile-sa-m2-project-skeleton-{{ deploy_version }}.tar.gz | Package name generated by spbuilder, __to be provided after modifying composer.json project name__
deploy_shared_folders | - var<br/>  - pub/static<br/>  - pub/media<br/>  | Deployment shared folders
deploy_shared_files |  | Deployment shared files
nfs_mount_point |  | Path of NFS mount dir in webservers (eg: /mnt/nfs-data/). If empty, NFS parameters above are not used.
nfs_shared_folder_name |  | Relative path to nfs_mount_point for magento shared files (eg: shared)
shared_folders_on_nfs | [var/importexport,var/import_history,pub/media,pub/static/\_cache] | List of path linked from NFS to local shared folder (Avoid big I/O files like logs, reports, caches, etc...)
deploy_languages | en_US | For Magento static content generation
deploy_keep_releases | 3 | Release number to keep on delivery
specific_hosts | [myfront1,mydb,myredis] | Aliases to add in /etc/hosts if not defined. __WARNING:__ These aliases need to be added manually on the preproduction and production environments

## Default values for LXC

Variable | Default value
---------|--------------
magento_hostname | {{ magento_project_name }}.lxc
magento_mode | developer
magento_profiler | On
magento_profiler_type | html
magento_php_display_errors | On
magento_install_grunt | true
magento_install_maildev | true
magento_mysql_use_binlog | 0
magento_cron_every_minutes | 5

## Default values for Inte

Variable | Default value
---------|--------------
magento_hostname | magento.idf.intranet
magento_project_path | {{ magento_delivery_path }}/current
magento_source_path | {{ magento_project_path }}
magento_mode | developer
magento_php_display_errors | On
magento_install_maildev | true
delivery_authorized_users | delivery_authorized_smile_users + jenkins
magento_mysql_use_binlog | 0
magento_cron_every_minutes | 5

## Default values for Staging

Variable | Default value
---------|--------------
magento_hostname | staging.{{ magento_project_name }}.com
magento_project_path | {{ magento_delivery_path }}/current
magento_source_path | {{ magento_project_path }}
magento_mode | production
magento_mysql_use_binlog | 0

## Default values for Preprod

Variable | Default value
---------|--------------
magento_hostname | preprod.{{ magento_project_name }}.com
magento_project_path | {{ magento_delivery_path }}/current
magento_source_path | {{ magento_project_path }}
magento_mode | production
magento_varnish_memory_mb | 256
magento_varnish_enable_protection | all
magento_varnish_basic_auth | XXXXXXXXXXXXXXXXXXXXXXX

## Default values for Prod

Variable | Default value
---------|--------------
magento_hostname | www.{{ magento_project_name }}.com
magento_project_path | {{ magento_delivery_path }}/current
magento_source_path | {{ magento_project_path }}
magento_mode | production
specific_hosts | myfront2 added
magento_http_cache_hosts | myfront1:80 & myfront2:80
magento_varnish_memory_mb | 256
magento_varnish_enable_protection | bo-only
magento_varnish_basic_auth | XXXXXXXXXXXXXXXXXXXXXXX

## System parameters

See the associated ansible roles:

- [ansible-basicserver|/ansible/ansible-basicserver]
- [ansible-apache|/ansible/ansible-apache]
- [ansible-php|/ansible/ansible-php]
- [ansible-mysql-server|/ansible/ansible-mysql-server]
- [ansible-redis|/ansible/ansible-redis]
- [ansible-varnish|/ansible/ansible-varnish]
