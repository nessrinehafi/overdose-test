# Prerequisites on the host machine

The following lines concern **your** computer. it does not concern the *server* or the *lxc*.

**DO NOT INSTALL** anything on the *server* or on the *lxc*.

You must have a workstation under [SmileBuntu](https://wiki.smile.fr/view/Systeme.ConfigPostes/ConfigUbuntu),
or at least install all the [Smile Packages](https://wiki.smile.fr/view/Adminsys/UbuntuSmilebuntu)
(like [smile-ca](https://wiki.smile.fr/view/Systeme/ConfigPostes/SmileSSLCertificates#How_to_install_in_Linux) package).

## For Hosting and Developers

The following lines are necessary for provisioning process. They concern Hosting and Developers.

- LDAP:     You must install the **python-ldap** package
- LDAP:     You must [upload your SSH key to the LDAP ](https://wiki.smile.fr/view/Systeme/UsingSmileLDAP#Upload_your_SSH_key_to_the_LDAP)
- GIT:      You must install the **git** packages
- GIT:      You must have your ssh key linked with your [git account](https://git.smile.fr/profile/keys)
- Ansible:  *See below*.

**Ansible**:

You must install **pipenv** to let the skeleton manage its Python dependencies:

```bash
sudo apt install python-pip libldap2-dev libsasl2-dev
pip install --user pipenv
```

*Note:* if **pipenv** is not in your `PATH`, make sure your `PATH` contains `/home/<user>/.local/bin`

*\[DEPRECATED!\]* If **pipenv** is not installed, the skeleton will use Ansible available on your system. In this case, you must [install and configure Ansible](https://wiki.smile.fr/view/Systeme/AnsibleIntro) manually.
The skeleton is compatible with Ansible 2.5.x.

## Only For Developers

The following lines are necessary to develop on the Magento project. They concern only Developers.

- LXC: You must [install and configure](https://wiki.smile.fr/view/Dirtech/LxcForDevs) the lxc management tools 
- PHP: You must install PHP and the `php-xml` extension
- Composer: You must [install](https://getcomposer.org/doc/00-intro.md#globally) Composer in the last stable version
- Composer: You must [configure](https://wiki.smile.fr/view/PHP/HowToConfigComposer) Composer to add Smile repositories
- Magento repository key: You must [Get your Magento repository key from your Magento account](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html) and add it in your __~/.composer/auth.json__

```
{
    "github-oauth": {
        "github.com": "[Your Github key]"
    },
    "http-basic": {
        "repo.magento.com": {
            "username": "[Public Key]",
            "password": "[Private Key]"
        }
    }
}
```

*Note: For Magento EE, you need use the EE repository key*
