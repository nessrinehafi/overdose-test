# Sub-Domain

## Usage

If you want to use Sub domains (for media, admin, ...), you can use the `magento_server_alias` parameter.

You have to fill it with the list of the values that you need, in the good inventory file depending on the concerned environment.

## Example with LXC

For example, if you want to use the following urls on you lxc environment:

- www.myproject.lxc
- media.myproject.lxc
- admin.myproject.lxc

You have to:

- Modify the parameter `magento_server_alias` of the file `./architecture/provisioning/inventory/group_vars/lxc`

    ```
    magento_server_alias:
     - "www.{{ magento_project_name }}.lxc"
     - "media.{{ magento_project_name }}.lxc"
     - "admin.{{ magento_project_name }}.lxc"
    ```

- Modify the file `./lxcfile` to add the following line, for automatic configuration when deploying your lxc:

    ```
    vhosts=www.myproject.lxc admin.myproject.lxc media.myproject.lxc
    ```

- If your LXC has already been deployed, you have to add the vhost manually:

    ```
    sudo caddvhost myproject www.myproject.lxc
    sudo caddvhost myproject admin.myproject.lxc
    sudo caddvhost myproject media.myproject.lxc
    ```

- Launch the provisioning script:

    ```
    ./architecture/scripts/provision.sh lxc --limit=webservers --tags=update_app
    ```

    Or full alternative:

    ```
    ./architecture/scripts/provision.sh lxc
    ```

- Use the [Smile Reconfigure](https://git.smile.fr/magento2/module-reconfigure) module, to configure automatically the urls to use for the lxc:

    ```
        <environment code="lxc" name="Smile LXC Development">
            <default>
                <web>
                    <unsecure>
                        <base_url>http://www.myproject.lxc/</base_url>
                        <base_static_url>http://www.myproject.lxc/pub/static/</base_static_url>
                        <base_media_url>http://media.myproject.lxc/pub/media/</base_media_url>
                    </unsecure>
                    <secure>
                        <base_url>https://www.myproject.lxc/</base_url>
                        <base_static_url>https://www.myproject.lxc/pub/static/</base_static_url>
                        <base_media_url>https://media.myproject.lxc/pub/media/</base_media_url>
                        <use_in_frontend>1</use_in_frontend>
                        <use_in_adminhtml>1</use_in_adminhtml>
                    </secure>
                    <cookie>
                        <cookie_domain>myproject.lxc</cookie_domain>
                    </cookie>
                </web>
                <admin>
                    <url>
                        <use_custom>1</use_custom>
                        <custom>https://admin.myproject.lxc/</custom>
                    </url>
                </admin>
            </default>
            <stores>
                <admin>
                    <web>
                        <unsecure>
                            <base_url>https://admin.myproject.lxc/</base_url>
                            <base_static_url>https://admin.myproject.lxc/pub/static/</base_static_url>
                            <base_media_url>https://admin.myproject.lxc/pub/media/</base_media_url>
                        </unsecure>
                        <secure>
                            <base_url>https://admin.myproject.lxc/</base_url>
                            <base_static_url>https://admin.myproject.lxc/pub/static/</base_static_url>
                            <base_media_url>https://admin.myproject.lxc/pub/media/</base_media_url>
                        </secure>
                    </web>
                </admin>
            </stores>
        </environment>
    ```

- Launch Smile Reconfigure:

    ```
    ./architecture/scripts/magento.sh lxc smilereconfigure:apply-conf -e lxc
    ./architecture/scripts/cache-clean.sh lxc
    ```
