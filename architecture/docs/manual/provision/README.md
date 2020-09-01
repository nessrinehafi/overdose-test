!INCLUDE "../project.conf"

<!--logo_subtitle=Documentation-->
<!--title=Magento2 Technical Installation Manual-->
<!--subtitle=-->
<!--date=2019-03-26-->
<!--version=1.4-->
<!--author=Laurent MINGUET-->
<!--client_logo_path=-->

# Introduction

The host of the website must be known.
The value `<project_host>` will be used in this document.

The url of the back-office must be known.
The value `/<project_bo_url>` will be used in this document.

Two front servers will be used.
If only one front is used, only the directives on the `myfront1` server must be followed.
If more than two fronts are used, the directives of the `myfront2` server must be followed for the other fronts.

On the front servers:

- Nginx will only manage https (it will listen on port <nginx_port_ssl>, and will redirect to the port <nginx_port>).
- Varnich will only manage http (it will listen on port <varnish_port>, and redirect to the port <apache_port>).
- Apache will only listen on the port <apache_port>, and redirect php files to PHP-FPM.

<warning> Nginx is not required, if the used load-balancer (that dispatches the traffic between the fronts) can:

- Manage the SSL certificate
- Send the http header `X-Forwarded-Proto` if https is used.
- Identify if an url concern the `/<project_bo_url>` back-office URL, and send the corresponding traffic only to the `myfront1` server.

<warning> The following features do not depend on Magento Architecture, and must be configured directly by the hosting team:

- Load balancer (be careful, the Magento BO must only be associated to the first front server).
- NFS server (to share media resources between the front servers).
- Replication (for MySQL, ElasticSearch, Redis).
- Backup strategy.
- Rotatelog.

# Prerequisites

## Servers

The following servers must be prepared:

- myfront1
- myfront2
- mydb
- myredis
- myelasticsearch

Each server:

- must be initialized with [Ubuntu Bionic 18.04](https://www.ubuntu.com/download/server) (Magento 2.3) or [Debian Stretch 9](https://www.debian.org/releases/stretch/) (Magento <= 2.2)
- must be initialized with the `en-US.UTF-8 UTF-8` locale
- must be contactable by the other servers

## Technical Account

<warning> This part is a good practice in order to avoid using the `root` user, but it is not mandatory.
If you do not create the `admin` account, and continue to use the `root` account, then all the commands must be executed without using `sudo`.

The list of the technical users's ssh public key must be known.

A technical account must be created.
It will be named `admin`.

On each server, using the `root` account:

```
apt-get install sudo
apt-get install vim
groupadd admin
useradd -g admin -s /bin/bash -m admin
sudo -u admin mkdir -p /home/admin/.ssh/
```

Add the ssh public key of all the authorized technical users in the authorized_keys file

```
sudo -u admin vim /home/admin/.ssh/authorized_keys
```

Edit the following file to allow sudo usage:

```
vim /etc/sudoers.d/admin
```

  > add these lines:

```
admin ALL=(ALL:ALL) NOPASSWD:ALL
```

Then, test the new `admin` account for each server:

```
ssh admin@XXXXX
pwd
sudo -s
exit
exit
```

From this point, only the `admin` account will be used.

## Root Account

<warning> This part is a good practice, but is not mandatory. 

The comment of the main account `root` of each server must have the name of the server in suffix.
This allows to have more readable mails in case of cron error with automatic email sending.
The following command must be executed on each server, with `XXXXX` corresponding to the name of the server:

```
sudo usermod root -c root-XXXXX
```

The main account `root` must not be used directly anymore.
The access to the `root` account via ssh can be disabled (it must only be used locally).

## Hosts Alias

We will use aliases instead of ip addresses for communication between services.
First, open the `/etc/hosts` file on each server:

```
sudo vim /etc/hosts
```

Then, add the following content in the file. The `ip` of each alias must be replaced by the ip of each server.

```
# Magento Alias
xx.xx.xx.xx myfront1
xx.xx.xx.xx myfront2
xx.xx.xx.xx mydb
xx.xx.xx.xx myredis
xx.xx.xx.xx myelasticsearch
```

In the `/etc/hosts` file of the `myfront1` and `myfront2` servers, it is also a good practice to add a line for the url that will be used for the Magento website:

```
127.0.0.1 <project_host>
```

# Generic Actions

The following actions must be executed on each server, with the `admin` account.

## Configure APT

It is a good practice to disable the recommends packages.

```
sudo vim /etc/apt/apt.conf
```

Add the following line:

```
aptitude::Recommends-Important "false";
```

## Upgrade

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y autoremove
```

## Basic Packages

```
sudo apt-get -y install aptitude
sudo apt-get -y install ca-certificates
sudo apt-get -y install bash-completion
sudo apt-get -y install diffutils
sudo apt-get -y install file
sudo apt-get -y install iproute
sudo apt-get -y install less
sudo apt-get -y install lsof
sudo apt-get -y install moreutils
sudo apt-get -y install mutt
sudo apt-get -y install patch
sudo apt-get -y install psmisc
sudo apt-get -y install rsync
sudo apt-get -y install screen
sudo apt-get -y install ssh
sudo apt-get -y install ssl-cert
sudo apt-get -y install strace
sudo apt-get -y install tcpdump
sudo apt-get -y install telnet
sudo apt-get -y install unzip
sudo apt-get -y install curl
sudo apt-get -y install ntp
sudo apt-get -y install acpid
sudo apt-get -y install iotop
sudo apt-get -y install dstat
sudo apt-get -y install apt-transport-https
sudo apt-get -y install tar
sudo apt-get -y install wget
sudo apt-get -y install lsb-release
```

## Useless Packages

```
sudo apt-get -y purge locate
sudo apt-get -y purge mlocate
sudo apt-get -y purge openbsd-inetd
```

## Delivery Account

The list of the delivery users's ssh public key must be known. 

A specific delivery account `smile` will be created, and those public keys will be authorized.
This delivery account will have sudo rights to reload services as `root`, and to launch every command as `<php_fpm_group>` (the magento execution user).

```
sudo groupadd <php_fpm_group>
sudo useradd -g <php_fpm_group> -s /bin/bash -m smile
sudo -u smile mkdir -p /home/smile/.ssh/
sudo -u smile vim /home/smile/.ssh/authorized_keys
```

Add the ssh public key of all the authorized delivery users:

```
sudo vim /etc/sudoers.d/smile
```

Add the following lines:

```
Cmnd_Alias SMILESERVICEALLOWED=@tocomplete@  
smile ALL=(<php_fpm_group>) NOPASSWD: ALL  
smile ALL=(root) NOPASSWD: SMILESERVICEALLOWED
```

The `@tocomplete@` part must be replaced by the following commands, depending on the services that will be installed on each server:

**Required**

- myfrontX

    - /bin/systemctl status <php_service_name>
    - /bin/systemctl reload <php_service_name>

**Optional**

- myfrontX

    - /bin/systemctl status nginx.service
    - /bin/systemctl reload nginx.service
    - /bin/systemctl status varnish.service
    - /bin/systemctl reload varnish.service
    - /bin/systemctl status apache2.service
    - /bin/systemctl reload apache2.service

- mydb:

    - /bin/systemctl status mysql.service
    - /bin/systemctl reload mysql.service

- myredis:

    - /bin/systemctl status redis-server@magento_cache.service
    - /bin/systemctl reload redis-server@magento_cache.service
    - /bin/systemctl status redis-server@magento_session.service
    - /bin/systemctl reload redis-server@magento_session.service

- myelasticsearch:

    - /bin/systemctl status elasticsearch.service
    - /bin/systemctl reload elasticsearch.service

Example:

```
Cmnd_Alias SMILESERVICEALLOWED=/bin/systemctl status <php_service_name>, /bin/systemctl reload <php_service_name>
```

Then, the sudo configuration must be checked:

```
sudo bash -c "chmod 440 /etc/sudoers.d/*"
sudo visudo -c
```

# MySQL Server

All the following commands must be executed using the `admin` account, on the `mydb` server.

## Sql implementation

<warning> The Percona package is used, but MySQL or MariaDB can be used instead.

## Add repository

```
wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
dpkg -i percona-release_latest.generic_all.deb
rm -f percona-release_latest.generic_all.deb
apt-get update
```

## Install package

```
apt-get -y install python-mysqldb
apt-get -y install percona-server-server
```

## Strong password generation

A strong password can be generated and used for the mysql `root` user. The following file can be created in order to not having to write the mysql `root` password each time the `root` user is connecting to mysql through the CLI:

```
ROOT_PASS=`date +%s | sha256sum | base64 | head -c 32 ; echo`
mysqladmin -u root password ${ROOT_PASS}
touch /root/.my.cnf
chmod 600 /root/.my.cnf
echo "[client]"              >  /root/.my.cnf
echo "user=root"             >> /root/.my.cnf
echo "password=${ROOT_PASS}" >> /root/.my.cnf
```

### Global Configuration

```
sudo systemctl stop mysql
sudo systemctl status mysql
sudo mkdir -p /etc/mysql/conf.d
sudo mkdir -p /var/log/mysql
sudo chown mysql.adm /var/log/mysql
cat /etc/mysql/my.cnf | grep includedir
```

It must return the following line:

```
!includedir /etc/mysql/conf.d/
```

Specific configuration must be added:

```
sudo vim /etc/mysql/conf.d/provision.cnf
```

The following lines must be added and eventually tuned accordingly:

```
!INCLUDE "mysql/provision.cnf"
```

Then, the mysql service can be started:

```
sudo bash -c "rm -f /var/lib/mysql/ib*"
sudo bash -c "rm -rf /var/lib/mysql/mysql/innodb_*"
sudo bash -c "rm -rf /var/lib/mysql/mysql/slave_*"
sudo systemctl start mysql
sudo systemctl is-enabled mysql || sudo systemctl enable mysql
sudo systemctl status mysql
```

### Create the Database

```
sudo mysql -e "SHOW DATABASES;"

sudo mysql -e "CREATE DATABASE IF NOT EXISTS <project_name> CHARACTER SET utf8 COLLATE utf8_general_ci" 
```

### Create the user

A strong password must be generated for the `<project_name>` user:

```
sudo mysql -e "CREATE USER '<project_name>'@'%' IDENTIFIED BY 'password';"

sudo mysql -e "GRANT USAGE ON * . * TO '<project_name>'@'%' IDENTIFIED BY 'password' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"

sudo mysql -e "GRANT ALL PRIVILEGES ON <project_name>.* TO '<project_name>'@'%' WITH GRANT OPTION ;"
```

## Test the instance

The following commands can be launched on the `myfront1` and `myfront2` servers to test if the database is correctly set.

Launch this command only if `myfrontX` and `mydb` are 2 separate servers:

```
sudo apt-get -y install mysql-client
```

Then, test the connection to the database:

```
mysql -h mydb -u <project_name> -p <project_name> -e "SHOW TABLES;"
```

Enter the password of the `<project_name>` account.

# Redis Server

All the following commands must be executed using the `admin` account, on the `myredis` server.


## Install the Packages

```
sudo apt-get -y install redis-server
```

## Configure 

### Cache Instance

```
sudo vim /etc/redis/redis_magento_cache.conf
```

The following lines must be added:

```
!INCLUDE "redis/cache.conf"
```

### Session Instance

```
sudo vim /etc/redis/redis_magento_session.conf
```

The following lines must be added:

```
!INCLUDE "redis/session.conf"
```

### Multi-Instance Mode

The Multi-instance mode must be used:

```
sudo vim /etc/systemd/system/redis-server@.service
```

The following lines must be added:

```
!INCLUDE "redis/redis-server@.service"
```

Then, the Single-instance mode must be disabled:

```
sudo systemctl daemon-reload
sudo systemctl stop redis-server
sudo systemctl disable redis-server
```

Finally, the cache and session redis instances can be enable and launched.

```
sudo systemctl enable redis-server@magento_cache
sudo systemctl enable redis-server@magento_session
sudo systemctl start redis-server@magento_cache
sudo systemctl start redis-server@magento_session
sudo systemctl status redis-server@magento_cache
sudo systemctl status redis-server@magento_session
```

## Test the Instances

The following commands can be launched on the `myfront1` and `myfront2` servers to test if redis is correctly configured.

```
telnet myredis 6379
```

  > flushall  
  > quit  

```
telnet myredis 6380
```

  > flushall  
  > quit  

# ElasticSearch Server

All the following commands must be executed using the `admin` account, on the `myelasticsearch` server.

## Install the Packages

```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
```

The ElasticSearch version must be locked, because of plugin issues when upgrading ElasticSearch.

```
sudo vim /etc/apt/preferences.d/elasticsearch
```

The following lines must be added:

```
Package: elasticsearch
Pin: version 6.6.2
Pin-Priority: 1001
```

The Java dependency must be installed manually:

```
sudo apt-get -y install openjdk-8-jdk
```

<warning> It is possible to use the official version of Java instead of `openjdk-8`.

Then, the package can be installed:

```
sudo apt-get -y install elasticsearch
sudo dpkg -l elasticsearch
sudo systemctl daemon-reload
```

## Configure

### Global Configuration

The file `/etc/elasticsearch/elasticsearch.yml` can be updated with thoses values:

- cluster.name: <project_name>
- path.data: /var/lib/elasticsearch
- path.logs: /var/log/elasticsearch
- node.master: true
- node.data: true
- bootstrap.memory_lock: false
- network.bind_host: 0

The file `/etc/default/elasticsearch` can be updated with thoses values:

- MAX_LOCKED_MEMORY=unlimited
- ES_JAVA_OPTS="-Xms1g -Xmx1g"

### Service

```
sudo systemctl restart elasticsearch
sudo systemctl is-enabled elasticsearch || sudo systemctl enable elasticsearch
sudo systemctl status  elasticsearch
curl myelasticsearch:9200
```

### Plugins

```
cd /usr/share/elasticsearch/
sudo bin/elasticsearch-plugin install analysis-phonetic
sudo bin/elasticsearch-plugin install analysis-icu
sudo systemctl restart elasticsearch
curl myelasticsearch:9200
```

## Test the Instances

The following commands can be launched on the `myfront1` and `myfront2` servers to test if elasticsearch is correctly configured:

```
curl myelasticsearch:9200
```

It must return the `<project_name>` cluster name .

# Front Servers

All the following commands must be executed using the `admin` account, on the `myfront1` and `myfront2` servers.

## Prepare the Magento folder

```
sudo mkdir -p <main_www_folder>/<project_name>
sudo chown smile <main_www_folder>/<project_name>
sudo chmod 755 <main_www_folder>/<project_name>

sudo -u smile mkdir -p <main_www_folder>/<project_name>/current/pub

sudo -u smile bash -c 'echo "helloworld <?php echo date(\"H:i:s\").\"\\n\"; ?>" > <main_www_folder>/<project_name>/current/pub/index.php'
```

## Nginx

<warning> Nginx is not required, if the used load-balancer (that dispatches the traffic between the fronts) can:

- Manage the SSL certificate
- Send the http header `X-Forwarded-Proto` if https is used.
- Identify if an url is part of the `/<project_bo_url>` back-office URL, and send the corresponding traffic only to the `myfront1` server.
  
### Install the packages

```
sudo apt-get -y install nginx
```

### Configure

The ssl certificate files must be placed in the /etc/ssl folder. Example:

- /etc/ssl/certs/ssl-cert-mybrand.pem
- /etc/ssl/private/ssl-cert-mybrand.key

The default site must be disabled:

```
sudo rm -f /etc/nginx/sites-enabled/default
```

The <project_name> site must be created:

```
sudo vim /etc/nginx/sites-available/<project_name>-ssl
```

The following lines must be added:

```
!INCLUDE "nginx/magento-ssl"
```

The new <project_name> site must be enabled:

```
sudo ln -sf /etc/nginx/sites-available/<project_name>-ssl /etc/nginx/sites-enabled/<project_name>-ssl
```

### Service

```
sudo systemctl daemon-reload
sudo systemctl restart nginx
sudo systemctl is-enabled nginx || sudo systemctl enable nginx
sudo systemctl status nginx
```

## Varnish

### Prerequisite on stretch

There is an temporary issue with varnish on this OS version.

```
sudo su
mkdir -p /etc/systemd/system/varnishncsa.service.d
touch /etc/systemd/system/varnishncsa.service.d/override.conf
echo "[Service]"            >> /etc/systemd/system/varnishncsa.service.d/override.conf
echo "PrivateNetwork=false" >> /etc/systemd/system/varnishncsa.service.d/override.conf
```

The file `/usr/sbin/varnish_reload_vcl` must be created with the following content:

```
!INCLUDE "varnish/varnish_reload_vcl_stretch"
```

Assign the appropriate execution modes to this file

```
chmod 755 /usr/sbin/varnish_reload_vcl
```

### Install the Packages

```
sudo apt-get -y install varnish
sudo varnishd -V
```

You must have the 5.x version on Ubuntu Server 18.04, or 4.1.x version on Debian Stretch.

### Configure

The file `/etc/default/varnish` must be updated with the following content:

```
!INCLUDE "varnish/default"
```

Warning: The admin url is used in the vcl file, it must be change to the final value.

The file `/etc/varnish/<project_name>.vcl` must be created with the following content:

```
!INCLUDE "varnish/magento.vcl"
```

The probe part must be included only if Magento version is at least 2.3.

### Service

The file `/etc/systemd/system/varnish.service` must be created with the following content:

```
!INCLUDE "varnish/varnish.service"
```

The file `/etc/systemd/system/varnishncsa.service` must be created with the following content:

```
!INCLUDE "varnish/varnishncsa.service"
```

Finaly, the services can be restarted:

```
sudo systemctl daemon-reload
sudo systemctl restart varnish
sudo systemctl restart varnishncsa
sudo systemctl is-enabled varnish || sudo systemctl enable varnish
sudo systemctl is-enabled varnishncsa || sudo systemctl enable varnishncsa
sudo systemctl status varnish
sudo systemctl status varnishncsa
```

## Apache

### Install the Packages

```
sudo apt-get -y install apache2
sudo apt-get -y install apache2-mpm-event
sudo apache2 -v
```

### Configure

Apache must only listen on port <apache_port>:

```
sudo bash -c 'echo "Listen <apache_port>" > /etc/apache2/ports.conf'
```

The remoteip module must be configured:

```
sudo bash -c 'echo "RemoteIPHeader X-Forwarded-For"   > /etc/apache2/mods-available/remoteip.conf'
sudo bash -c 'echo "RemoteIPInternalProxy 127.0.0.1" >> /etc/apache2/mods-available/remoteip.conf'
```

Some modules must be enabled:

```
sudo a2enmod deflate
sudo a2enmod expires
sudo a2enmod headers
sudo a2enmod proxy_fcgi
sudo a2enmod remoteip
sudo a2enmod rewrite
```

The default websites must be disabled:

```
sudo rm -f /etc/apache2/sites-enabled/000-default.conf
sudo rm -f /etc/apache2/sites-enabled/default_ssl.conf
```

The file `/etc/apache2/conf-available/security.conf` must be replaced with the following content:

```
!INCLUDE "apache/security.conf"
```

The file `/etc/apache2/conf-available/smile-logformats.conf` must be created with the following content:

<warning> This specific log format is a good practice, but is not mandatory. You can use your own.

```
!INCLUDE "apache/smile-logformats.conf"
```

Those configuration files must be enabled:

```
sudo ln -sf /etc/apache2/conf-available/security.conf /etc/apache2/conf-enabled/
sudo ln -sf /etc/apache2/conf-available/smile-logformats.conf /etc/apache2/conf-enabled/
```

The file `/etc/apache2/sites-available/<project_name>.conf` must be created with the following content:

<warning> If you don't use the specific smile log format, you have to change the corresponding code in the apache virtualhost.

```
!INCLUDE "apache/magento.conf"
```

The new <project_name> site must be enabled:

```
sudo ln -sf /etc/apache2/sites-available/<project_name>.conf /etc/apache2/sites-enabled/<project_name>.conf
```

The configuration can be tested with

```
sudo apache2ctl -S
```

### Service

```
sudo systemctl daemon-reload
sudo systemctl restart apache2
sudo systemctl status apache2
```

## PHP

The PHP-FPM package will be used, instead the php-mod for apache.

### Install the Packages

```
apt-get install -y <php_version>-fpm
apt-get install -y <php_version>-bcmath
apt-get install -y <php_version>-curl
apt-get install -y <php_version>-gd
apt-get install -y <php_version>-iconv
apt-get install -y <php_version>-intl
apt-get install -y <php_version>-json
apt-get install -y <php_version>-mbstring
apt-get install -y <php_version>-mysql
apt-get install -y <php_version>-pdo
apt-get install -y <php_version>-pdo-mysql
apt-get install -y <php_version>-readline
apt-get install -y <php_version>-redis
apt-get install -y <php_version>-simplexml
apt-get install -y <php_version>-soap
apt-get install -y <php_version>-xml
apt-get install -y <php_version>-xsl
apt-get install -y <php_version>-zip

php -v
```

On Debian Stretch (Magento <= 2.2), add the following package:

```
apt-get install -y php<php_version>-mcrypt
```

### Configure

The file `/etc/php/<php_version>/fpm/conf.d/80-provision.ini` must be created with the following content:

```
!INCLUDE "php/80-provision-fpm.ini"
```

The file `/etc/php/<php_version>/cli/conf.d/80-provision.ini` must be created with the following content:

```
!INCLUDE "php/80-provision-cli.ini"
```

The default pool must be removed:

```
sudo rm -f /etc/<php_version>/fpm/pool.d/*
```

The file `/etc/php/<php_version>/fpm/pool.d/<project_name>.conf` must be created with the following content:

```
!INCLUDE "php/magento.conf"
```

### Service

```
sudo systemctl daemon-reload
sudo systemctl restart <php_version>-fpm
sudo systemctl is-enabled <php_version>-fpm || systemctl enable <php_version>-fpm
sudo systemctl status <php_version>-fpm
```

## Test the instances

The following commands can be launched on the `myfront1` and `myfront2` servers to test if the webservers are correctly configured.

```
curl http://localhost/
```

It must display `helloworld` with the current hour.

Finally, the access to each front server must be tested from an external web browser. 
It must display `helloworld` with the current hour.

## Cleaning

Once all is configured:

- The following folder can be deleted: `<main_www_folder>/<project_name>/current`.
- The project team can deliver the code and start the install process.
