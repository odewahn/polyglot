# polyglot
Code for my Becoming a Polyglot talk

In this repository are examples in several languages of a basic API in a common framework for that language.  They all use the same mongodb backend, and all use the same single page HTML application.

All of them run at http://localhost:3000

The following paths work in each environment:
* /api/quotes => quote list
* /api/quotes/random => random quote
* / => hello world from the framework
* /demo => Single page HTML application

# Setup
You will need to have mongodb installed and running.  Installation info for the major platforms is at https://docs.mongodb.org/manual/installation/


To insert the information from the quoteid.json file to get your DB started, use the following command:

`mongoimport --collection quotes --file ../data/quoteid.json --type json --jsonArray`

# PHP
$ php composer.phar install 
```
$ pecl install mongo
$ php -i | grep ini
$ php -S 0.0.0.0:3000 -t ./public/ ./public/index.php
```

# Python
`cd python; python setup.py install; python flask-server.py`

# Node
`cd node; npm install; node express-server.js`
`cd node; npm install; node hapi-server.js`

# Ruby
`cd ruby; gem install bundler; bundle install; ruby sinatra-server.rb`

# Perl
`sudo cpan -i -f Dancer Dancer::Plugin::CRUD JSON MongoDB; perl dancer-server.pl`

# Docker setup
You can skip all of the setup instructions below and use the docker container if you like.
First, install docker from http://www.docker.com/toolkit
Next:
  * Start the docker shortcut utility, note the IP address it gives
  * `docker run -i -t -p 80:3000 synedra/polyglot /bin/bash`
  * `/etc/init.d/mongodb start`
  * `cd ../data`
  * `mongoimport --collection quotes --file ../data/quoteid.json --type json --jsonArray`
  * run the startup command for whichever language you like
  * The server will be running on http://{docker-ip}


