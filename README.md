# polyglot
Code for my Becoming a Polyglot talk

Slides are available at: http://www.slideshare.net/synedra/polyglot-copy

Many people understand the very basics of several languages, all the way to Hello World. However, this isn’t a full fledged application and it’s challenging to make the translations in your head between all the different dialects (interpreted languages aren’t really different from each other like different languages – they work very much the same and the only difference is in the structure of the language). Out in our community are many people who firmly believe that moving from Ruby to Perl is not possible, that it’s very difficult to learn a new language, that it makes no sense to try to understand what “foreign” code might be doing.

In this repository are examples in several languages of a basic API in a common framework for that language.  They all use the same mongodb backend, and all use the same single page HTML application.

All of them run at http://{server}:8080

The following paths work in each environment:
* /api/quotes => quote list
* /api/quotes/random => random quote
* / => hello world from the framework
* /demo => Single page HTML application

# Setup
You will need to have mongodb installed and running.  Installation info for the major platforms is at https://docs.mongodb.org/manual/installation/


To insert the information from the quoteid.json file to get your DB started, use the following command:

`mongoimport --collection quotes --file data/quoteid.json --type json --jsonArray`

# Python
`cd python; pip install --user -r requirements.txt; python flask-server.py`

# Node
`cd node; npm install; node express-server.js`
`cd node; npm install; node hapi-server.js`

# Ruby
`cd ruby; gem install bundler; bundle install; ruby sinatra-server.rb`

# Perl
`sudo cpan -i -f Dancer Dancer::Plugin::CRUD JSON MongoDB; perl dancer-server.pl`

# PHP

```
$ php composer.phar install 

$ pecl install mongo
$ php -i | grep ini - add extension=mongo.so to this file, or create it
$ php -S 0.0.0.0:8080 -t ./public/ ./public/index.php
```

# Docker setup
You can skip all of the setup instructions above and use the docker container if you like.
First, install docker from http://www.docker.com/toolkit

Next:
  * Start the docker shortcut utility
  * `docker run -i -t -p 8080:8080 synedra/polyglot`
  * `/etc/init.d/mongodb start`
  * `mongoimport --collection quotes --file data/quoteid.json --type json --jsonArray`
  * run the startup command for whichever language you like
   * cd python; python flask-server.py
   * cd perl; perl dancer-server.py
   * cd ruby; ruby sinatra-server.py
   * cd node; node express-server.py
   * cd php; php -S 0.0.0.0:8080 -t ./public/ ./public/index.php
  * The server will be running on http://localhost:8080
  * Check [http://localhost:8080](http://localhost:8080) to see the welcome message
  * Check [http://localhost:8080/api/quotes](http://localhost:8080/api/quotes) to see the JSON API response
  * Check [http://localhost:8080/demo](http://localhost:8080/demo) to see the front page application.  Use the chrome developer tools to watch the traffic on the backend and play with the frontend
