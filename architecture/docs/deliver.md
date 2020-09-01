# Deliver the sources

## 0 - Prepare

### 0.1 - Ansible Version

You must have Ansible between 2.4 and 2.5

```
$ ansible --version
```

### 0.2 - Ansible Server Configuration

Modify the integration/staging/preprod/prod parameters.
 
Specify the correct hostname and all the specific configuration of your integration/staging/preprod/prod environment:

- ./{architecture}/provisioning/inventory/[inte,staging,preprod,prod]
- ./{architecture}/provisioning/inventory/group_vars/[inte,staging,preprod,prod]
 
### 0.3 - Prepare a Package

You can follow the [packaging](./packaging.md) documentation to prepare a package.

## 1 - Provision

First, you can provision your integration/staging/preprod/prod environment with the same provisioning script as for the LXC
to initialise the environment or deploy new configurations (from the *architecture folder*)
```
$ ./scripts/provision.sh [inte,staging,preprod,prod]
```

_Note: On the first execution, add the servers keys in the `architecture/known_hosts` file to be able to certify hosts authenticity, and commit this file._

You have to do this each time the provision configuration has change.

**Important:** On Preproduction and Production environments, you must complete the `varnish_basic_auth` parameter by the values given by the hosting team.

**Important:** If you are on an environment with separate servers for Redis, Mysql, and Elastic Search, after the first provisioning,
you must ask to the Hosting to update the **IP** the alias **myfrontX**, **mydb**, **myredis**, ... in the **/etc/hosts** file of each servers.

**Important:** If you are on an Production environment, you must modify manually the memory configuration, by following this documentation:
 https://wiki.smile.fr/view/Hosting/ElasticSearch#Memory_Setting

## 2 - Delivery

### 2.1 - Delivery

Then, we will deliver the archive (see [Packaging documentation](./packaging.md)) using Ansible (from the *architecture folder*).
```
$ ./scripts/deploy.sh [inte,staging,preprod,prod] [-p packageVersion or -b VCSbranch or -t VCStag] [-f] [-s]
```

> If the script doesn't find the requested package it will try to generate it with `vendor/bin/spbuilder package -n --force-version="master-20160307120000"`

You must use the **[-f]** parameter if it is the **first deploy** and if the database is not set up.

You must use the **[-s]** parameter if you want to launch the setups and put the maintenance flag.

> If you do not use the [-s] parameter and if some setups need to be launched, an error will occur and the delivery will not be done.
> If you use the [-s] parameter and if no setup needs to be launched, the maintenance flag won't be activated.

Ansible will:

- Copy the archive on the remote environment
- Create the releases/shared/current folder structure
- Unarchive in the releases folder
- Add the Symlinks to the shared folders
- Deploy the env.php files
- Add the maintenance flag if needed
- Launch the setup if needed
- Genereate the di and static content if production mode is enabled
- Remove the maintenance flag if needed
- Modify the symlink "current"
 
> **Note**: The deploy.yml ansible script take 2 extra vars:
>  * first_install [Y/N]
>  * setup_upgrade [Y/N]

### 2.2 - Shared on NFS - First Deployment Only

__On the first deployment and if you have a NFS__, move the multi-front shared folders and files from the shared directory and create symlinks:

- pub/media
- pub/static/_cache
- var/importexport
- var/import_history
 
### 2.3 - Database Init - First Deployment Only

__On the first deployment__, you can also install Magento database and cron using the installation script (from the *architecture folder*).

```
$ ./scripts/install.sh [inte,staging,preprod,prod]
$ ./scripts/setup-upgrade.sh [inte,staging,preprod,prod]
```

## 3 - Post Actions

### 3.1 - Reconfigure

If you use Smile Reconfigure module, you can also run those commands (from the *architecture folder*).

```
$ ./scripts/magento.sh [inte,staging,preprod,prod] smilereconfigure:apply-conf -e [inte,staging,preprod,prod]
$ ./scripts/cache-clean.sh [inte,staging,preprod,prod]
```

### 3.2 - Static and DI - First Deployment Only

__On the first deployment and if the magento_mode is production__, you need to generate static and di files (from the *architecture folder*)

```
$ ./scripts/generate-static-di.sh [inte,staging,preprod,prod]
```

On the next deployements, the deploy script does it automatically.
