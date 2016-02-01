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
You will need to have mongodb installed and running.  To insert the information from the quoteid.json file to get your DB started, use the following command:

`mongoimport --collection quotes --file ../data/quoteid.json --type json --jsonArray`

# PHP
$ php composer.phar install 
```
$ pecl install mongo
$ php -i | grep ini
$ php -S 0.0.0.0:8080 -t ./public/ ./public/index.php
```

# Python
`cd python; python setup.py install; python flask-server.py`

# Node
`cd node; npm install; node express-server.js`

`cd node; npm install; node hapi-server.js`

# Ruby
`cd ruby; gem install bundler; bundle install; ruby sinatra-server.rb`

# Perl
`sudo cpan -i Dancer; perl dancer-server.pl`
