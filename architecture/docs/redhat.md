# Using Redhat 7

Before executing the provision script, you must register your system.

You must have a account on https://access.redhat.com/labs/registrationassistant/ .

For LXC / Inte, you can use a dev account. You must subscribe on this page: https://developers.redhat.com/auth/realms/rhd/account/.


Then, go on your server via ssh, with the `root` user, and execute the following commands:

```
yum install subscription-manager
subscription-manager register
subscription-manager refresh
subscription-manager attach --auto
```

Then, add the Collection for RedHat 7 (to have PHP 7 support):

```
subscription-manager repos --enable rhel-server-rhscl-7-rpms
```

More info here: https://access.redhat.com/solutions/253273

Then, you can launch the provision script.
