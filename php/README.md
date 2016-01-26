# Slim 3 Rest API

## Installation of Slim 3

Install composer:

```
$ curl -sS https://getcomposer.org/installer | php
```

This will create a `composer.phar` in your CWD.

Install Slim3 skeleton:

```
$ php composer.phar create-project slim/slim-skeleton slim3-rest-api
$ cd slim3-rest-api
```

To use Mongo, you _will_ need the mongo extension:

```
$ pecl install mongo
```

and if it warns you, add it to your php.ini, `extension=mongo.so`, you can probably use this one-liner:

```
$ echo 'extension=mongo.so' >> `php -i | grep Loaded | grep 'php.ini' | awk '{print $NF}'`
```

## Edit the Code

Simply edit `src/routes.php`    