# Grunt for theme development

## Installation

[Official Doc](http://devdocs.magento.com/guides/v2.0/frontend-dev-guide/css-topics/css_debug.html#grunt_prereq)

On LXC env, NPM and Grunt-CLI are already installed (Ansible parameter magento_install_grunt).

You have just to do this:

- Create the file `dev/tools/grunt/configs/themes-smile.js` file and put your theme definition:

    ```
    'use strict';
    
    module.exports = {
        my_project_theme: {
            area: 'frontend',
            name: 'MyProject/my_project_theme',
            locale: 'en_US',
            files: [
                'css/styles-m',
                'css/styles-l'
            ],
            dsl: 'less'
        }
    };
    ```

- Copy the file `package.json.sample` to `package.json` (without any modification).

- Copy the file `Gruntfile.js.sample` to `Gruntfile.js` (without any modification).

- **Magento <= 2.1:** modify the file `Gruntfile.js` to extend the `themes` variable with the new theme config file:

    ```
    var _ = require('underscore'),
        path = require('path'),
        themes = require('./dev/tools/grunt/configs/themes'),
        themesSmile = require('./dev/tools/grunt/configs/themes-smile'),
        configDir = './dev/tools/grunt/configs',
        tasks = grunt.file.expand('./dev/tools/grunt/tasks/*');

    _.extend(themes, themesSmile);
    ```

- **Magento >= 2.2:** copy the file `grunt-config.json.sample` to `grunt-config.json` and set the name of the theme config file to `themes-smile`

- Launch the following commands to install npm needed packages:

    ```
    $ ssh root@myproject.lxc
    $ cd /var/www/myproject/
    $ npm install
    $ npm update
    $ exit
    ```

- Launch the following commands in your architecture folder to test grunt:

    ```
    $ ./scripts/permissions.sh lxc
    $ ./scripts/grunt.sh lxc 
    ```

- Commit the 4 files you have created.

## Usage

To use grunt while developing a theme, you need to put frontend workflow on server side mode in Configuration > Developper > Frontend workflow.
Then follow those steps:

- Build static files: `./scripts/magento.sh lxc setup:static-content:deploy`
- Update permission: `./scripts/permissions.sh lxc`
- Run exec grunt task: `./scripts/grunt.sh lxc exec:YOURTHEMENAME`
- Run less grunt task: `./scripts/grunt.sh lxc less:YOURTHEMENAME`
- Run watch grunt task: `./scripts/grunt.sh lxc watch:YOURTHEMENAME`
