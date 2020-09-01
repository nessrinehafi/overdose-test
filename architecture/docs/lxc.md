# LXC deployment on existing project

## Step 1

Clone your magento project repository.

Clone your architecture project repository (if it has been separated).
 
## Step 2

Go to your *project folder* and run those commands:

```
$ composer install
```

## Step 3

Go to your *project folder* and run this command:

```
$ sudo cdeploy
```

This command will create a new lxc.

For RedHat, you **must** read [this documentation](redhat.md) before executing the provision script.

Go to your *architecture folder* and run this command:

```
$ bash scripts/provision.sh lxc
```

This command will provision the lxc with Ansible playbook.

## Step 4

Go to your *architecture folder* and run those commands:

```
$ ./scripts/install.sh lxc
$ ./scripts/setup-upgrade.sh lxc
```

If the project uses Smile Reconfigure module, you must also run those commands:

```
$ ./scripts/magento.sh lxc smilereconfigure:apply-conf -e lxc
$ ./scripts/cache-clean.sh lxc
```

## Step 5

To test your fresh installation, go to:
 
- http://[PROJECT_NAME].lxc/                   for the front-office
- http://[PROJECT_NAME].lxc/admin/             for the back-office (login: admin, password: magent0)
- http://[PROJECT_NAME].lxc:1080/              for the maildev interface
- http://[PROJECT_NAME].lxc:9200/_plugin/head/ for the elastic search interface
 
__That's all folks__

## Full Init Script

You can find a example of script to init your lxc here: [full-init.sh](https://git.smile.fr/magento2/dev-modules/blob/master/_extra/scripts/full-init.sh)
