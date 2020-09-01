# Build Magento VirtualHost

This analyse has been made on a Magento CE 2.2.0

## Procedure

In first, you must locate all the `.htaccess` files:

```bash
find . -name '.htaccess' | grep -v 'vendor/magento/magento2-base' | sort
```

Main Files:

```
./.htaccess
./pub/.htaccess
```

Sub Files:

```
./app/.htaccess
./bin/.htaccess
./dev/.htaccess
./generated/.htaccess
./lib/.htaccess
./phpserver/.htaccess
./pub/errors/.htaccess
./pub/media/customer/.htaccess
./pub/media/downloadable/.htaccess
./pub/media/.htaccess
./pub/media/import/.htaccess
./pub/media/theme_customization/.htaccess
./pub/static/.htaccess
./setup/config/.htaccess
./setup/.htaccess
./setup/performance-toolkit/.htaccess
./setup/pub/.htaccess
./setup/src/.htaccess
./setup/view/.htaccess
./update/app/.htaccess
./update/dev/.htaccess
./update/.htaccess
./update/pub/.htaccess
./update/var/.htaccess
./var/composer_home/cache/.htaccess
./var/composer_home/.htaccess
./var/.htaccess
./vendor/.htaccess
```

## Generic directives

This part is the Skeleton generic one. It does not depend on the Magento `.htaccess` files.

    # FILE MANAGED BY ANSIBLE: DO NOT EDIT !!!
    # {{ ansible_managed }}
    {% set vhost_name    = item.value.vhost_name|default(item.key) %}
    {% set vhost_params  = item.value %}
    {% set document_root = vhost_params.document_root %}
    {% set ssl_enabled   = vhost_params.ssl is defined and vhost_params.ssl.enabled|default(false) %}
    {% if ansible_os_family == 'Debian' %}{% set _logpath = '${APACHE_LOG_DIR}' %}{% endif %}
    {% if ansible_os_family == 'RedHat' %}{% set _logpath = 'logs' %}{% endif %}
    {% set magento_pub_dir = 'pub/' %}
    {% if magento_mode == 'production' %}{% set magento_pub_dir = '' %}{% endif %}
    <VirtualHost *:{{ apache2_ssl_port if ssl_enabled else apache2_port }}>
        ServerName   {{ vhost_params.server_name|default(ansible_fqdn) }}
    
    {% for alias in vhost_params.server_aliases|default([]) %}
        ServerAlias  {{ alias }}
    {% endfor %}
    
    {% if ssl_enabled %}
        # SSL Enabled
        SSLEngine             on
        SSLCertificateFile    {{ vhost_params.ssl.certificate_file|default(apache2_default_ssl_cert) }}
        SSLCertificateKeyFile {{ vhost_params.ssl.certificate_key_file|default(apache2_default_ssl_key) }}
    {% endif %}
    
        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript
    
        Header set X-Content-Type-Options "nosniff"
        Header set X-XSS-Protection "1; mode=block"
    
        SetEnvIf X-Forwarded-Proto "^https$" HTTPS=on
    
    {% if vhost_params.environment_vars is defined %}
    {%     for env_var_name, env_var_value in vhost_params.environment_vars.iteritems()|default([]) %}
        SetEnv {{ env_var_name }} {{ env_var_value }}
    {%     endfor %}
    {% endif %}
    {% if magento_profiler %}
        SetEnv MAGE_PROFILER {{ magento_profiler_type }}
    {% endif %}
    
        #######################################################
        # Add here the specific directives from .htaccess files
        #######################################################
    
    {% if magento_php_mode == 'fpm' %}
        ## PHP-FPM
        <FilesMatch "\.php$">
            SetHandler "proxy:fcgi://localhost:9000"
        </FilesMatch>
    {% endif %}
    
        ErrorLog    {{ _logpath }}/error-{{ vhost_name }}.log
        CustomLog   {{ _logpath }}/access-{{ vhost_name }}.log smile_combined_remoteip
    </VirtualHost>

**IMPORTANT** the following lines must be removed from the original .htaccess file:

        BrowserMatch ^Mozilla/4 gzip-only-text/html
        BrowserMatch ^Mozilla/4\.0[678] no-gzip
        BrowserMatch \bMSIE !no-gzip !gzip-only-text/html
        SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|png)$ no-gzip dont-vary
        Header append Vary User-Agent env=!dont-vary


## Analyse of .htaccess files

### Main Files ./pub/.htaccess and ./.htaccess

        # BEGIN ./pub/.htaccess and ./.htaccess
    {% if magento_mode == 'production' %}
        DocumentRoot {{ document_root }}/pub
    {% else %}
        DocumentRoot {{ document_root }}
    {% endif %}
    
        DirectoryIndex index.php
    
        <Directory {{ document_root }}>
            Options -Indexes +FollowSymLinks
            AllowOverride None
            Require all granted
        </Directory>
    
        <IfModule mod_security.c>
            SecFilterEngine Off
            SecFilterScanPOST Off
        </IfModule>
    
        RewriteEngine on
    
        ####################################
        # Add the other .htaccess directives
        ####################################
    
        RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
        RewriteCond %{REQUEST_METHOD} ^TRAC[EK]
        RewriteRule .* - [L,R=405]
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_FILENAME} !-f
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_FILENAME} !-d
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_FILENAME} !-l
        RewriteRule .* /index.php [L]
    
        AddDefaultCharset Off
        AddType 'text/html; charset=UTF-8' html
    
        ExpiresDefault "access plus 1 year"
        ExpiresByType text/html A0
        ExpiresByType text/plain A0
    
        Header set X-Frame-Options SAMEORIGIN
    
        ErrorDocument 404 /{{ magento_pub_dir }}errors/404.php
        ErrorDocument 403 /{{ magento_pub_dir }}errors/404.php
        # END ./pub/.htaccess and ./.htaccess

### Setup Wizard

Add this part to enable the setup wizard if needed

        # Enable those lines only if you want to access to the setup wizard
        #<Directory "{{ document_root }}/setup">
        #    Options -Indexes
        #    RewriteEngine off
        #</Directory>
        #RewriteRule setup/.* - [L]

### Swagger

Add this part to enbale the swagger if needed


    {% if not magento_enable_swagger %}
        # Disable access to swagger interface
        RewriteRule ^/swagger.* - [L,R=404]
    {% endif %}

### Deny From All

For all the following folders:

- ./app
- ./bin
- ./dev
- ./generated
- ./lib
- ./phpserver
- ./pub/media/customer
- ./pub/media/downloadable
- ./pub/media/import
- ./scripts
- ./setup
- ./update
- ./var
- ./vendor

We must deny the access:

        # BEGIN - Deny From All
        <Directory ~ "{{ document_root }}/(app|bin|dev|generated|lib|phpserver|scripts|setup|update|var|vendor)">
            Order deny,allow
            Deny from all
        </Directory>
    
        <Directory ~ "{{ document_root }}/pub/media/(customer|downloadable|import)">
            Order deny,allow
            Deny from all
        </Directory>
        # END - Deny From All

So we can ignore the following .htaccess files:

- ./app/.htaccess
- ./bin/.htaccess
- ./dev/.htaccess
- ./generated/.htaccess
- ./lib/.htaccess
- ./phpserver/.htaccess
- ./pub/media/customer/.htaccess
- ./pub/media/downloadable/.htaccess
- ./pub/media/import/.htaccess
- ./setup/config/.htaccess
- ./setup/performance-toolkit/.htaccess
- ./setup/pub/.htaccess
- ./setup/src/.htaccess
- ./setup/view/.htaccess
- ./setup/.htaccess
- ./update/app/.htaccess
- ./update/dev/.htaccess
- ./update/.htaccess
- ./update/pub/.htaccess
- ./update/var/.htaccess
- ./var/composer_home/cache/.htaccess
- ./var/composer_home/.htaccess
- ./var/.htaccess
- ./vendor/.htaccess

### File ./pub/errors/.htaccess

```
# BEGIN ./pub/errors/.htaccess
<Directory "{{ document_root }}/pub/errors">
    Options None
    RewriteEngine Off
</Directory>
# END ./pub/errors/.htaccess
```

### File ./pub/media/theme_customization/.htaccess

```
# BEGIN ./pub/media/theme_customization/.htaccess
<Directory "{{ document_root }}/pub/media/theme_customization">
    Options All -Indexes
    <Files ~ "\.xml$">
        Order allow,deny
        Deny from all
    </Files>
</Directory>
# END ./pub/media/theme_customization/.htaccess
```

### File ./pub/media/.htaccess

```
# BEGIN ./pub/media/.htaccess
<Directory "{{ document_root }}/pub/media">
{% if magento_php_mode != 'fpm' %}
    php_flag engine 0
{% else %}
    <FilesMatch "\.(ph(p[3457]?|t|tml)|[aj]sp|p[ly]|sh|cgi|shtml?|html?)$">
        SetHandler None
        ForceType text/plain
    </FilesMatch>
{% endif %}

    Options -Indexes -MultiViews -ExecCGI +FollowSymLinks

    ############################################
    ## setting MIME types

    AddType application/javascript js jsonp
    AddType application/json json
    AddType text/css css
    AddType image/x-icon ico
    AddType image/gif gif
    AddType image/png png
    AddType image/jpeg jpg
    AddType image/jpeg jpeg
    AddType image/svg+xml svg
    AddType application/vnd.ms-fontobject eot
    AddType application/x-font-ttf ttf
    AddType application/x-font-otf otf
    AddType application/x-font-woff woff
    AddType application/font-woff2 woff2
    AddType application/x-shockwave-flash swf
    AddType application/zip gzip
    AddType application/x-gzip gz gzip
    AddType application/x-bzip2 bz2
    AddType text/csv csv
    AddType application/xml xml

    <FilesMatch .*\.(ico|jpg|jpeg|png|gif|svg|js|css|swf|eot|ttf|otf|woff|woff2)$>
        Header append Cache-Control public
    </FilesMatch>

    <FilesMatch .*\.(zip|gz|gzip|bz2|csv|xml)$>
        Header append Cache-Control no-store
    </FilesMatch>

    ############################################
    ## Add default Expires header
    ## http://developer.yahoo.com/performance/rules.html#expires
    ExpiresActive On

    # Data
    <FilesMatch \.(zip|gz|gzip|bz2|csv|xml)$>
        ExpiresDefault "access plus 0 seconds"
    </FilesMatch>
    ExpiresByType text/xml "access plus 0 seconds"
    ExpiresByType text/csv "access plus 0 seconds"
    ExpiresByType application/json "access plus 0 seconds"
    ExpiresByType application/zip "access plus 0 seconds"
    ExpiresByType application/x-gzip "access plus 0 seconds"
    ExpiresByType application/x-bzip2 "access plus 0 seconds"

    # CSS, JavaScript
    <FilesMatch \.(css|js)$>
        ExpiresDefault "access plus 1 year"
    </FilesMatch>
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"

    # Favicon, images, flash
    <FilesMatch \.(ico|gif|png|jpg|jpeg|swf|svg)$>
        ExpiresDefault "access plus 1 year"
    </FilesMatch>
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"

    # Fonts
    <FilesMatch \.(eot|ttf|otf|svg|woff|woff2)$>
        ExpiresDefault "access plus 1 year"
    </FilesMatch>
    ExpiresByType application/vnd.ms-fontobject "access plus 1 year"
    ExpiresByType application/x-font-ttf "access plus 1 year"
    ExpiresByType application/x-font-otf "access plus 1 year"
    ExpiresByType application/x-font-woff "access plus 1 year"
    ExpiresByType application/font-woff2 "access plus 1 year"
</Directory>

## never rewrite for existing files
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_FILENAME} !-f
RewriteRule ^/{{ magento_pub_dir }}media/(.+)$ /{{ magento_pub_dir }}get.php [L]
RewriteRule ^/({{ magento_pub_dir }}media/.*) %{DOCUMENT_ROOT}/$1 [L]

# END ./pub/media/.htaccess
```

### File ./pub/static/.htaccess

```
# BEGIN ./pub/static/.htaccess
<Directory "{{ document_root }}/pub/static">
{% if magento_php_mode != 'fpm' %}
    php_flag engine 0
{% else %}
    <FilesMatch "\.(ph(p[3457]?|t|tml)|[aj]sp|p[ly]|sh|cgi)$">
        SetHandler None
        ForceType text/plain
    </FilesMatch>
{% endif %}

    # To avoid situation when web server automatically adds extension to path
    Options -MultiViews

    ############################################
    ## setting MIME types

    AddType application/javascript js jsonp
    AddType application/json json
    AddType text/html html
    AddType text/css css
    AddType image/x-icon ico
    AddType image/gif gif
    AddType image/png png
    AddType image/jpeg jpg
    AddType image/jpeg jpeg
    AddType image/svg+xml svg
    AddType application/vnd.ms-fontobject eot
    AddType application/x-font-ttf ttf
    AddType application/x-font-otf otf
    AddType application/x-font-woff woff
    AddType application/font-woff2 woff2
    AddType application/x-shockwave-flash swf
    AddType application/zip gzip
    AddType application/x-gzip gz gzip
    AddType application/x-bzip2 bz2
    AddType text/csv csv
    AddType application/xml xml

    <FilesMatch .*\.(ico|jpg|jpeg|png|gif|svg|js|css|swf|eot|ttf|otf|woff|woff2)$>
        Header append Cache-Control public
    </FilesMatch>

    <FilesMatch .*\.(zip|gz|gzip|bz2|csv|xml)$>
        Header append Cache-Control no-store
    </FilesMatch>

    ############################################
    ## Add default Expires header
    ## http://developer.yahoo.com/performance/rules.html#expires
    ExpiresActive On

    # Data
    <FilesMatch \.(zip|gz|gzip|bz2|csv|xml)$>
        ExpiresDefault "access plus 0 seconds"
    </FilesMatch>
    ExpiresByType text/xml "access plus 0 seconds"
    ExpiresByType text/csv "access plus 0 seconds"
    ExpiresByType application/json "access plus 0 seconds"
    ExpiresByType application/zip "access plus 0 seconds"
    ExpiresByType application/x-gzip "access plus 0 seconds"
    ExpiresByType application/x-bzip2 "access plus 0 seconds"

    # CSS, JavaScript
    <FilesMatch \.(css|js|html)$>
        ExpiresDefault "access plus 1 year"
    </FilesMatch>
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType text/html "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"

    # Favicon, images, flash
    <FilesMatch \.(ico|gif|png|jpg|jpeg|swf|svg)$>
        ExpiresDefault "access plus 1 year"
    </FilesMatch>
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"

    # Fonts
    <FilesMatch \.(eot|ttf|otf|svg|woff|woff2)$>
        ExpiresDefault "access plus 1 year"
    </FilesMatch>
    ExpiresByType application/vnd.ms-fontobject "access plus 1 year"
    ExpiresByType application/x-font-ttf "access plus 1 year"
    ExpiresByType application/x-font-otf "access plus 1 year"
    ExpiresByType application/x-font-woff "access plus 1 year"
    ExpiresByType application/font-woff2 "access plus 1 year"
</Directory>

# Remove signature of the static files that is used to overcome the browser cache
RewriteRule ^/{{ magento_pub_dir }}static/version.+?/(.+)$ /{{ magento_pub_dir }}static/$1
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_FILENAME} !-f
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_FILENAME} !-l
RewriteRule ^/{{ magento_pub_dir }}static/(.+)$ /{{ magento_pub_dir }}static.php?resource=$1 [L]
RewriteRule ^/({{ magento_pub_dir }}static/.*) %{DOCUMENT_ROOT}/$1 [L]

# END ./pub/static/.htaccess
```
