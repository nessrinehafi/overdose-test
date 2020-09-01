# Unit test

## Launching Magento Unit tests

First, you need to **generate the DI**:

```
$ ./scripts/generate-static-di.sh lxc
```

Then, on the LXC:

```
$ sudo -u www-data bin/magento dev:tests:run unit
```

[See Magento documentation](http://devdocs.magento.com/guides/v2.0/config-guide/cli/config-cli-subcommands-test.html)

## Creating tests

With Magento 2, you are able to create unit tests. Magento Framework provides utility classes to help writing them.  
/vendor/magento/framework/TestFramework

You can also use the utility classes provided by the Smile Library Framework:  
https://git.smile.fr/magento2/library-framework/tree/master/TestFramework

Your tests must be in the **Test/Unit** folder of your modules.
Here is some quick test examples for:

- Rewrite
- Plugin
- Observer

https://git.smile.fr/magento2/training_2.1/tree/unit_test/app/code/Training/Helloworld/Test/Unit

- Repository

https://git.smile.fr/magento2/training_2.1/tree/unit_test/app/code/Training/Seller/Test/Unit

## Running your tests

You can run your tests using the same command as for Magento tests on the LXC:

```
$ sudo -u www-data bin/magento dev:tests:run unit
```

But this will also launch all the Magento tests (takes several minutes), which is useless when you don't modify the Magento core. (**and you mustn't !**)

You can also define your own **phpunit.xml** file to run only your tests.
https://git.smile.fr/magento2/training_2.1/blob/unit_test/phpunit.xml

You will be able to launch your tests (in or outside the LXC):

```
$ ./vendor/bin/phpunit -c phpunit.xml
```

## Using CI platform

You can also configure SPBuilder to launch these tests.
https://git.smile.fr/magento2/training_2.1/blob/unit_test/.spbuilder.yml

Be careful to desactivate the globals backup, SPBuilder won't work if it is activated: **backupGlobals="false"**. And don't forget to generate the DI.
