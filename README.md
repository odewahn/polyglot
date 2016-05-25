# polyglot
Code for my Becoming a Polyglot talk

In this repository are examples in several languages of a basic API in a common framework for that language.  They all use the same mongodb backend, and all use the same single page HTML application.

All of them run at http://localhost:8080

The following paths work in each environment:
* /api/quotes => quote list
* /api/quotes/random => random quote
* / => hello world from the framework
* /demo => Single page HTML application

# Setup
You will need to have mongodb installed and running.  Installation info for the major platforms is at https://docs.mongodb.org/manual/installation/


To insert the information from the quoteid.json file to get your DB started, use the following command:

`mongoimport --collection quotes --file ../data/quoteid.json --type json --jsonArray`

```
# PHP
$ php composer.phar install 

$ pecl install mongo
$ php -i | grep ini - add extension=mongo.so to this file, or create it
$ php -S 0.0.0.0:8080 -t ./public/ ./public/index.php
```

# Python
`cd python; pip install -r requirements.txt; python flask-server.py`

# Node
`cd node; npm install; node express-server.js`
`cd node; npm install; node hapi-server.js`

# Ruby
`cd ruby; gem install bundler; bundle install; ruby sinatra-server.rb`

# Perl
`sudo cpan -i -f Dancer Dancer::Plugin::CRUD JSON MongoDB; perl dancer-server.pl`

# Docker setup
You can skip all of the setup instructions above and use the docker container if you like.
First, install docker from http://www.docker.com/toolkit
Next:
  * Start the docker shortcut utility, note the IP address it gives
  * `docker run -i -t -p 8080:8080 synedra/polyglot`
  * `/etc/init.d/mongodb start`
  * `mongoimport --collection quotes --file ../data/quoteid.json --type json --jsonArray`
  * run the startup command for whichever language you like
  * The server will be running on http://{docker-ip}:8080


# Cloud 9

Alternatively, you can use Cloud 9 (https://c9.io) to setup a cloud-based containerised environment. In order to run all of the versions, you'll need to create an image based on PHP.  Further instructions for getting PHP to run are below.
 * Setup a new workspace based on the 'PHP/Apache' image, cloning from this repo
 * Run the setup needed for PHP
```
$ cd php
$ php composer.phar install 
$ sudo apt-get install php5 php5-dev libapache2-mod-php5 apache2-threaded-dev php-pear php5-mongo
$ wget http://pecl.php.net/get/mongo
$ sudo pecl install mongo
```
 * For all languages, to run mongo, start the following command in a separate terminal on c9.
```
$ ./mongod
$ mongoimport --collection quotes --file data/quoteid.json --type json --jsonArray
```
 * In a new tab: follow the Setup instructions for the PHP, Python, Node, Ruby and Perl instructions as usual.
