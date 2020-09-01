# Initialise your project

## Step 1

Go to your favorite working directory and run the following command:

```
$ bash <(curl -sL https://git.smile.fr/magento2/architecture-skeleton/raw/master/init.sh)
```

__A prompt will ask you__:

- The project name. It needs to be a lowercase alphanum (`[a-z0-9]`)
- If it is a Magento Cloud project (Y or N)
- Classic Project: The magento edition you need (CE or EE)
- Classic Project: The magento version you need (2.x.x)
- Classic Project: If you want the sample data  (Y or N)
- Classic Project: If you want to create a separate project for the architecture  (Y or N)
- Cloud Project: The git url of the magento cloud project
- Cloud Project: The Smile Public ACL Username to use (for https://packagists.smile.fr)
- Cloud Project: The Smile Public ACL Password to use (for https://packagists.smile.fr)
- If you want to install the Smile modules (Y or N)
- The default smile user (current user by default) to authorise for delivery. Ex: lamin
  
Then you will need to confirm your choices.
 
This command will __initialize the project__ using composer. The files will be organized differently depending on your answer on the architecture separation:

- Not separated: a folder called `myproject` for magento, with a subfolder `architecture`.
- Separated: a folder called `myproject_magento` for magento, and a folder called `myproject_architecture` for the architecture.

Because it's a convention based installation, by default everything depends on your project name: vhost, mysql user, mysql password, mysql database, ...

If you need more flexibility, you need to edit the right files in `{architecture}/provisioning/inventory/group_vars/` and customize vars according to your needs.

If you choose to set a custom delivery user (e.g. smile) you must edit the Ansible configuration file __provisioning/inventory/group_vars/all__ and add all users that need a SSH access to the servers:

```
delivery_authorized_smile_users:
  - mabes
```

See the [Ansible parameter list](docs/parameters.md).

## Step 2.1 - Classical Project

__Initialize your git repository__, by following this procedure:

- Go to https://git.smile.fr/groups/new and create a new git group with the name of your project (example: xxxxx)
- Go to https://git.smile.fr/projects/new and create a project named **magento** in your new git group (i.e. Project owner)
- You can go to your git project with the following url https://git.smile.fr/xxxxx/magento
- Go to your magento project folder and execute the following commands:
 
```
git init
git remote add origin git@git.smile.fr:xxxxx/magento.git
git add .
git commit -m "init the magento project"
git push -u origin master
```


## Step 2.1 - Cloud Project

You can create a new "develop" branch, and commit all files that were changed during the init process. 

Do not forget to activate this branch on the Magento Cloud interface, to initiate the associated environment.


## Step 2.2 - Separate Architecture

If you have separated the magento project and the architecture project, you need to also follow this procedure:

- Go to https://git.smile.fr/projects/new and create a project named **architecture** in your new git group (i.e. Project owner)
- You can go to your git project with the following url https://git.smile.fr/xxxxx/architecture
- Go to your architecture project folder and execute the following commands:
 
```
git init
git remote add origin git@git.smile.fr:xxxxx/architecture.git
git add .
git commit -m "init the architecture project"
git push -u origin master
```


## Step 3

When all the sources are downloaded, you need to go to your *project folder* and run this command:

```
$ sudo cdeploy
```

This command will create a new lxc.

By default, it uses a Debian `stretch` template for Magento < 2.3, and Ubuntu `bionic` template for Magento 2.3.
You can edit the `lxcfile` to change it, and use one of the following values:

- Debian 9 - PHP 7.0: `stretch`
- Debian 10 - PHP 7.3: `debian-10-buster`
- Ubuntu Xenial (16.04) - PHP 7.0: `xenial`
- Ubuntu Bionic (18.04) - PHP 7.2: `bionic`
- RedHat 7 - PHP 7.0: `rhel7`
- CentOS 7 - PHP 7.0: `centos7`

For RedHat, you **must** read [this documentation](redhat.md) before executing the next script.

Then, you have to:

- Change the composer.json file to set the php version used in the platform config.
- Run `composer update` to update the packages depending on the php version. 

Now, you can configure your LXC using the following command in the *architecture folder*:

```
$ ./scripts/provision.sh lxc
```

It will provision the lxc with Ansible playbook.

## Step 4

Now you can install Magento database using the following command in the *architecture folder*:

```
$ ./scripts/install.sh lxc
```

It may take some time to init the database, especially if you use Magento sample data.

## Step 5

You can now change some basic project configuration:

- In ./{magento}/composer.json:
    - name ([group_name]/[project_name])
    - description
- In ./{architecture}/provisioning/inventory/group_vars/all
    - magento_install_date: get it from the app/etc/env.php after the installation
    - magento_crypt_key: get it from the app/etc/env.php after the installation
    - delivery_authorized_smile_users: add the smile users that will be allowed to deliver
    - deploy_release_path: need to follow this structure __../../{magento}/build/dist/[git group name]-[git project name]-{{ deploy_version }}.tar.gz__
       WARNING: for this path, it must be changed if the architecture is separated from the magento sources.
- In ./{magento}/.spbuilder.yml
    - package.vcs.url: Provide your git URL
- In ./{magento}/JenkinsFile
    - Update the [magento git url], [git group name] and [git project name].

You can also change these files:

- ./README.md

__Commit all the sources__

## Step 6

To test your fresh installation, go to:

- http://[PROJECT_NAME].lxc/                   for the front-office
- http://[PROJECT_NAME].lxc/admin/             for the back-office (login: admin, password: magent0)
- http://[PROJECT_NAME].lxc:1080/              for the maildev interface
- http://[PROJECT_NAME].lxc:9200/_plugin/head/ for the elastic search interface

__Taste the sweet flavor of the so trendy magento2 new project factory__ :+1:
