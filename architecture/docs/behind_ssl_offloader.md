# Magento behind SSL Offloader / Load Balancer

When Magento is running behind SSL Offloader e.g. *.clients.smile.fr domains, on hosting etc, Nginx vhost must not serve SSL and must not override values of `X-Forwarded-For` and `X-Forwarded-Proto` HTTP headers provided by SSL Offloder / Load Balancer.

## Disable Nginx entierely (best solution)

Edit *provisioning/inventory/group_vars/all* file

magento_stack_use_nginx_offloader: False

## Other solution, setting up Nginx Vhost configuration

Edit *provisioning/inventory/group_vars/&lt;inventory&gt;* file, duplicate following section from *provisioning/inventory/group_vars/proxyservers*:

```
nginx_vhosts:
  magentosslvhost:
  ...
```

And disable specific settings:

```
...
override_x_forwarded_for:   False
override_x_forwarded_proto: False
ssl:
    enabled:                False
...
```

When done, Nginx will not listen on port 443 and will not override `X-Forwarded-For` and `X-Forwarded-Proto`  HTTP headers.

All settings can be set independently - you can still override HTTP headers but only disable SSL etc.
