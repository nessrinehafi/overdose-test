# Magento Patches

## Configure Composer

You must require the package `cweagans/composer-patches`:

```
composer require cweagans/composer-patches
```

It allows you to apply patches on modules installed with composer.

## Apply a Magento patch

With the package `cweagans/composer-patches`, Composer allows you to apply patches.

The problem is that you can:

- Only apply a patch to a specific module
- The patch file must use relative paths from the main folder of the module (ie without vendor/namespace/module/)

But Magento patches:

- Can modify lots of modules in one patch
- Use relative paths from the root folder  (ie with vendor/namespace/module/)

Then, when you want to apply a Magento official patch, you have to split it to have one file per module, with appropriate relative path.

Finally, you need to add them into the composer.json file:

```
    "extra": {
        ...
        "patches": {
            "magento/framework": {
                "MDVA-2551_EE_2.1_COMPOSER_v2": "_extra/patches/MDVA-2551_EE_2.1_COMPOSER_v2/magento-framework.patch"
            },
            "magento/module-catalog": {
                "MDVA-2551_EE_2.1_COMPOSER_v2": "_extra/patches/MDVA-2551_EE_2.1_COMPOSER_v2/magento-module-catalog.patch"
            },
            "magento/module-resource-connections": {
                "MDVA-2551_EE_2.1_COMPOSER_v2": "_extra/patches/MDVA-2551_EE_2.1_COMPOSER_v2/magento-module-resource-connections.patch"
            }
        }
    },
```

## Good Practices

Here are some good pratices:

- Create a folder `_extra/patches/`.
- Add a `README.md` file in the `_extra/patches/` folder, to list all the patches, and describ the purpose of each patch.
- Put the original Magento patch file without any modification in this folder.
- Create a subfolder with the same name of the path filename.
- Put in this subfolder the split files with appropriate relative paths.
- Do not forget to tell to spbuilder to remove the `_extra` folder when creating a package, by modifing the `.spbuilder.yml` file.

## Automatic Script

You can find a automatic script to split Magento patches here: https://git.smile.fr/magento2/dev-modules/tree/master/_extra/scripts/split-patches.php

It will:

- Analyse all the Magento patches in the folder `_extra/patches/`.
- Split them, use good relative path, and put them in the good sub folders.
- Modify the `composer.json` file to add them.
