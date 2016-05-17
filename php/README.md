# Slim 3 Rest API

## Installation

```
$ php composer.phar install 
```

To use Mongo, you _will_ need the mongo extension:

```
$ pecl install mongo
```

and if it warns you, add it to your php.ini, `extension=mongo.so`. Find your php.ini by using:

```
$ php -i | grep ini
```

If none is loaded, create one in the path it expects one.


## Edit the Code

Simply edit `src/routes.php`    

## Running the Server

From the root of the project (the same directory as this README) run the following:

```
$ php -S 0.0.0.0:3000 -t ./public/ ./public/index.php
```

This will start the PHP cli-server on port `3000`.
