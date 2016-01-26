// *******************************************
// DATABASE STUFF ****************************
// *******************************************
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/test');
var db = mongoose.connection;

var quoteSchema = mongoose.Schema({
        content: String,
        author: String,
        id: Number
});

var quotecount;
var Quote = mongoose.model('Quote', quoteSchema)
Quote.count().exec(function(err, count){
   quotecount = count;
});
// *******************************************

var Hapi = require('hapi');
var Inert = require('inert');
var Path = require('path');

var server = new Hapi.Server();
server.connection({ port: 3000 });
server.register(require('inert'), function(err) {
  
  if (err) {
    
    throw err;
  }
  
  server.route({
    method : 'GET', path : '/demo/{path*}', handler : {
      directory : {
        path : './static',
        listing : false,
        index : true
      }
    }
  });
  
});

server.route([
  {
    method: 'GET',
    path: '/api/quotes/random',
    handler: function(request, reply) {
      var random = Math.floor(Math.random() * quotecount);
      Quote.findOne({"id":random},
      function (err, result) {
        reply(result);
      })
    }
  },
{
    method: 'GET',
    path: '/api/quotes',
    handler: function(request, reply) {
      Quote.find({}, {}, {limit:10,sort:{'id':-1}},
      function (err, result) {
         reply(result);
      });
    }
  },
 {
    method: 'POST',
    path: '/api/quotes',
    handler: function(request, reply) {
        if(!request.payload.content) {
          return reply('Error 400: Post syntax incorrect.').code(400);
        }
        quotecount = quotecount+1; 
        var newQuote;
        if (request.payload.author) {
          newQuote = new Quote({'content': request.payload.content, 'author': request.payload.author, 'id': quotecount});
        } else {
         newQuote = new Quote({'content': request.payload.content, 'id':quotecount});
        }
        newQuote.save(function (err, newQuote) {
          if (err) return console.error(err);
          reply(quotecount);
      });
    }
  },
  {
    method: 'GET',
    path: '/api/quotes/{id}',
    handler: function(request, reply) {
    Quote.findOne({"id":request.params.id},
      function (err, result) {
        reply(result);
      });
    }
  },
{
    method: 'PUT',
    path: '/api/quotes/{id}',
    handler: function(request, reply) {
        if((!request.payload.content) && (!request.payload.author)) {
          return reply('Error 400: Post syntax incorrect.').code(400);
        }
        var query = {'id':request.params.id};
        var newQuote = new Quote();
        if (request.payload.author) {
         newQuote.author = request.payload.author;
        };
        if (request.payload.content) {
         newQuote.content = request.payload.content;
        };
        var upsertData = newQuote.toObject();
        delete upsertData._id;
        Quote.findOneAndUpdate(query, upsertData, {upsert:true}, function(err, doc){
          if (err)  {
            return reply({ error: err }).code(500);
          }
          return reply("succesfully saved");
        });
    }
  },
  {
    method: 'DELETE',
    path: '/api/quotes/{id}',
    handler: function(request, reply) {
        Quote.findOneAndRemove({"id":request.params.id},
          function (err, result) {
            if (!err) {
              reply(true);
            }
        });
    }
  },
  {
    method: 'GET',
    path: '/',
    handler: function(request, reply) {
      reply('Hello world from hapi');
    }
  }
]);

server.start(function() {
  console.log('Hapi is listening to http://localhost:3000');
});
