!INCLUDE "../project.conf"

<!--logo_subtitle=Documentation-->
<!--title=Magento2 Deploy Manual-->
<!--subtitle=-->
<!--date=2019-03-26-->
<!--version=1.4-->
<!--author=Laurent MINGUET-->
<!--client_logo_path=-->
<!--release_version=20190326_1730-->

# Prerequisites

The following servers must be prepared exactly like in the `Technical Installation Manual` document.

The `smile` delivery account must exist.

The `<main_www_folder>/<project_name>` folder must exist, and must be owned by the `smile` user.

A full archive package must have been generated by the production team.

A new unique release name must have been generate. Example: `<project_name>_<release_version>`.

The main front server (for cron jobs and maintenance actions) will be called `frontMain`. It corresponds to:

- myFront1

All the other front servers will be called `frontOthers`. It corresponds to:

- myFront2
- myFront3
- ...

You can separate proxy servers (varnish + nginx). No source files will be delivered on these servers. In this case they correspond to:

- myProxy1
- myProxy2
- ...

Only the `smile` user must be used during the procedure.

# Extract The Package

<warning> All the following actions must be made on `frontMain` and `frontOthers`.

## Prepare the Folder

Create the main release folder if it does not exist yet:

```
mkdir -p <main_www_folder>/<project_name>/releases
```

Verify that the `<main_www_folder>/<project_name>/releases/<project_name>_<release_version>` folder does not exist yet.

<error> If it already exist, the procedure must be stopped!

Create the new release folder:

```
mkdir -p <main_www_folder>/<project_name>/releases/<project_name>_<release_version>
```

Extract the archive package to the new release folder `<main_www_folder>/<project_name>/releases/<project_name>_<release_version>`.

## Initialize the Rights

The rights must be initialized as followed:

```
chown -R smile.root <main_www_folder>/<project_name>/releases/<project_name>_<release_version>
chmod -R 644 <main_www_folder>/<project_name>/releases/<project_name>_<release_version>
chmod -R +X <main_www_folder>/<project_name>/releases/<project_name>_<release_version>

chmod +x <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/bin/magento

chown -R smile.<php_fpm_group> <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/app/etc
chown -R smile.<php_fpm_group> <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/static
chown -R smile.<php_fpm_group> <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var

chmod -R g+w <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/app/etc
chmod -R g+w <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/static
chmod -R g+w <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var
```

# Prepare the Shared Folders and Files

<warning> This part must be executed only during the first deploy.

<warning> All the following actions must be made on `frontMain` and `frontOthers`.

## Create Shared Folders and Files

Create the main shared folder.

```
mkdir -p <main_www_folder>/<project_name>/shared
```

Create the shared folders and files.

```
mkdir -p <main_www_folder>/<project_name>/shared/var/log
mkdir -p <main_www_folder>/<project_name>/shared/var/report
mkdir -p <main_www_folder>/<project_name>/shared/var/importexport
mkdir -p <main_www_folder>/<project_name>/shared/var/import_history
mkdir -p <main_www_folder>/<project_name>/shared/pub/media
mkdir -p <main_www_folder>/<project_name>/shared/pub/static/_cache
mkdir -p <main_www_folder>/<project_name>/shared/app/etc
touch <main_www_folder>/<project_name>/shared/app/etc/config.php
touch <main_www_folder>/<project_name>/shared/app/etc/env.php
```

## Initialize the Contents

The shared file `<main_www_folder>/<project_name>/shared/app/etc/env.php` must be initialized with the following lines:

```
!INCLUDE "magento/env.php"
```

The shared file `<main_www_folder>/<project_name>/shared/app/etc/config.php` must be initialized with the following lines:

```
!INCLUDE "magento/config.php"
```

The media shared folder must be initialized with the files of the first release.

```
cp -r \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/media \
<main_www_folder>/<project_name>/shared/pub/
```

## Initialize the Rights

The rights must be initialized as followed:

```
chown smile.<php_fpm_group> <main_www_folder>/<project_name>/shared/var/log
chown smile.<php_fpm_group> <main_www_folder>/<project_name>/shared/var/report
chown smile.<php_fpm_group> <main_www_folder>/<project_name>/shared/var/importexport
chown smile.<php_fpm_group> <main_www_folder>/<project_name>/shared/var/import_history
chown smile.<php_fpm_group> <main_www_folder>/<project_name>/shared/app/etc/config.php
chown smile.<php_fpm_group> <main_www_folder>/<project_name>/shared/app/etc/env.php

chmod 775 <main_www_folder>/<project_name>/shared/var/log
chmod 775 <main_www_folder>/<project_name>/shared/var/report
chmod 775 <main_www_folder>/<project_name>/shared/var/importexport
chmod 775 <main_www_folder>/<project_name>/shared/var/import_history
chmod 664 <main_www_folder>/<project_name>/shared/app/etc/config.php
chmod 664 <main_www_folder>/<project_name>/shared/app/etc/env.php

chown -R smile.<php_fpm_group> <main_www_folder>/<project_name>/shared/pub
chmod -R 664 <main_www_folder>/<project_name>/shared/pub
chmod -R +X <main_www_folder>/<project_name>/shared/pub
```

## Share Between Fronts

The following folders and files must be shared between the fronts.

They must be moved from the shared directory to the NAS, and symlinks must be created to the shared folder:

- app/etc/config.php
- app/etc/env.php
- pub/media
- pub/static/_cache
- var/importexport
- var/import_history

# Use the Shared Folders and Files

<warning> All the following actions must be made on `frontMain` and `frontOthers`.

## Clean

Remove the shared folders and files in the release:

```
rm -rf <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/log
rm -rf <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/report
rm -rf <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/importexport
rm -rf <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/import_history
rm -rf <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/media
rm -rf <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/static/_cache
rm -rf <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/app/etc/config.php
rm -rf <main_www_folder>/<project_name>/releases/<project_name>_<release_version>/app/etc/env.php
```

## Create the Symlinks

The following symlinks must be created:

```
ln -s \
<main_www_folder>/<project_name>/shared/var/log \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/log

ln -s \
<main_www_folder>/<project_name>/shared/var/report \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/report

ln -s \
<main_www_folder>/<project_name>/shared/var/importexport \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/importexport

ln -s \
<main_www_folder>/<project_name>/shared/var/import_history \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/import_history

ln -s \
<main_www_folder>/<project_name>/shared/pub/media \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/media

ln -s \
<main_www_folder>/<project_name>/shared/pub/static/_cache \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/static/_cache

ln -s \
<main_www_folder>/<project_name>/shared/app/etc/config.php \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/app/etc/config.php

ln -s \
<main_www_folder>/<project_name>/shared/app/etc/env.php \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/app/etc/env.php
```

## Initialize the Rights

Restore the rights:

```
chown smile.<php_fpm_group> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/log

chown smile.<php_fpm_group> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/report

chown smile.<php_fpm_group> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/importexport

chown smile.<php_fpm_group> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/var/import_history

chown smile.<php_fpm_group> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/media

chown smile.<php_fpm_group> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/pub/static/_cache

chown smile.<php_fpm_group> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/app/etc/config.php
```

# Upgrade Magento

<warning> This part must be executed **only** if Magento has already been installed once.

<warning> All the following actions must be made on `frontMain` and `frontOthers`.

The Static and DI files must be generated:

```
sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/bin/magento setup:static-content:deploy \
--jobs 1 <project_language_default>

<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/bin/magento setup:static-content:deploy \
--jobs 1 <project_language_additional>

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/bin/magento setup:di:compile
```

The maintenance mode must be enabled on the previous release:

```
sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento maintenance:enable
```

<warning> All the following actions must be made only on `frontMain`.

The magento cron must be disabled, by commenting the following line in the `<php_fpm_user>` crontab:

```
#*/1 * * * * <main_www_folder>/<project_name>/current/bin/magento cron:run >> <main_www_folder>/<project_name>/current/var/log/magento.cron.log
```

Setups must be executed:

```
sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/bin/magento cache:clean config

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/bin/magento setup:upgrade --keep-generated

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/bin/magento smilesetup:execute-all
```


<warning> All the following actions must be made only on `frontMain`.

Clean cache of static files

```
sudo -u <php_fpm_user> \
rm -rf <main_www_folder>/<project_name>/shared/pub/static/_cache/*
```


<warning> All the following actions must be made on `frontMain` and `frontOthers`.

The current symlink must be updated:

```
rm -f <main_www_folder>/<project_name>/current

ln -s <main_www_folder>/<project_name>/releases/<project_name>_<release_version> <main_www_folder>/<project_name>/current
```

The maintenance mode is automatically disabled, because of the symlink switch.

<warning> All the following actions must be made only on `frontMain`.

The magento cron must be enabled, by activating the following line in the `<php_fpm_user>` crontab:

```
*/1 * * * * <main_www_folder>/<project_name>/current/bin/magento cron:run >> <main_www_folder>/<project_name>/current/var/log/magento.cron.log
```

# Install Magento

<warning> This part must be executed **only** if Magento has not been installed yet.

<warning> All the following actions must be made on `frontMain` and `frontOthers`.

The current symlink must be created:

```
ln -s <main_www_folder>/<project_name>/releases/<project_name>_<release_version> <main_www_folder>/<project_name>/current
```

<warning> All the following actions must be made only on `frontMain`.

Installer must be executed (The `db-password` parameter must be changed with the good value):

```
sudo -u <php_fpm_user> rm -rf <main_www_folder>/<project_name>/current/generation/*

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento setup:install \
 --admin-firstname=<project_name> \
 --admin-lastname=<project_name> \
 --admin-email=<project_email> \
 --admin-user=admin \
 --admin-password=magent0 \
 --backend-frontname=<project_bo_url> \
 --db-host=mydb \
 --db-name=<project_name> \
 --db-user=<project_name> \
 --db-password=XXXXXXXXXX \
 --base-url=http://<project_host>/ \
 --base-url-secure=https://<project_host>/ \
 --use-secure=<project_secure_frontend>
 --use-secure-admin=<project_secure_backend>
 --use-rewrites=1 \
 --currency=<project_currency> \
 --language=en_US \
 --timezone=Europe/Paris \
 --cleanup-database \
 --magento-init-params=\"MAGE_MODE=production\" \
 -vvv
```

Setups must be executed:

```
sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento cache:clean config

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento setup:upgrade

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento smilesetup:execute-all
```

The specific configurations must be executed (be carefull to use the good environment code):

```
sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento smilereconfigure:apply-conf -e [inte,preprod,prod]

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento cache:clean
```

<warning> All the following actions must be made on `frontMain` and `frontOthers`.

The Static and DI files must be generated:

```
sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento setup:static-content:deploy --jobs 1 <project_language_default>

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento setup:static-content:deploy --jobs 1 <project_language_additional>

sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/current/bin/magento setup:di:compile
```

<warning> All the following actions must be made only on `frontMain`.

The magento cron must be enabled, by added the following line in the `<php_fpm_user>` crontab:

```
*/1 * * * * <main_www_folder>/<project_name>/current/bin/magento cron:run >> <main_www_folder>/<project_name>/current/var/log/magento.cron.log
```

# Clean

<warning> All the following actions must be made on `frontMain` and `frontOthers`.

The `php-fpm` service must be reloaded, to clean OpCache, because of a symlink nativ bug:

```
sudo systemctl reload <php_service_name>
```

<warning> All the following actions must be made only on `frontMain`.

The magento cache must be cleaned:

```
sudo -u <php_fpm_user> \
<main_www_folder>/<project_name>/releases/<project_name>_<release_version>/bin/magento cache:clean
```

If needed, the old releases can be deleted. Only the last 3 releases can be keeped.