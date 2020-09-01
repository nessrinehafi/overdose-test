# Creating Magento 2 module for Smile

## Step 0

1. Analyse your code (checkstyle, PMD, SmileAnalyser, etc.) using [SPBuilder](https://git.smile.fr/dirtech/spbuilder)
2. Make [Unit Tests](unit_test.md)

## Step 1

Develop and test your module on the Magento 2 Dev Projet

1. Request access to https://git.smile.fr/magento2/dev-modules repository
2. Clone the repository
3. Install using the [full-init.sh](https://git.smile.fr/magento2/dev-modules/blob/master/_extra/scripts/full-init.sh) script
4. Add your module sources into `app/code/Smile`.
5. Create a module in `app/code/Example` that will use your module and serve as integration exemple 
6. Access the dev Magento 2 <http://m2modules.lxc> and test your module
7. Validate the code quality with SpBuilder

## Step 2

Create the repo for your module.

1. Submit a request to the technical direction for a repository creation under the Magento 2 group <https://git.smile.fr/groups/magento2>
2. Create this file hierarchy in your repo:
    - .gitignore
    - CHANGELOG.md
    - composer.json
    - CONTRIBUTING.md
    - LICENSE.md
    - README.md
3. Put your module sources directly in this folder 
4. Update the doc files by looking into another repo to respect the content organisation ex: <https://git.smile.fr/magento2/module-connector>

## Step 3

Once your module has been validated by the technical direction,
submit a contribution on capi: <https://capi.smile.fr/PHP/Magento2>

## Step 4

Add the deploy key "packagist.vitry.intranet" to your repo.

Ask to the technical direction to add your module to the Smile packagist magento2 repository.
