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

var express = require('express');
var app = express();
var router = express.Router();    
var path = require('path');
var bodyParser = require('body-parser');

app.use(express.static(path.join(__dirname, '..', 'static')));
app.use(bodyParser.json());

// REST API
router.route('/quotes/random')
.get(function(req, res, next) {
    var random = Math.floor(Math.random() * quotecount);
    Quote.findOne({"id":random},
    function (err, result) {
      if (err) {
        console.log(err);
        res.redirect('/quotes/random');
      }
     res.send(result);
    })
});

router.route('/quotes')
.get(function(req, res, next) {
    Quote.find({}, {}, {limit:10},
      function (err, result) {
         res.send(result);
   });
})
.post(function(req, res, next) {
  if(!req.body.hasOwnProperty('content')) {
    res.statusCode = 400;
    return res.send('Error 400: Post syntax incorrect.');
  }
  quotecount = quotecount+1; 
  var newQuote;
  if (req.body.hasOwnProperty('author')) {
    newQuote = new Quote({'content': req.body.content, 'author': req.body.author, 'id': quotecount});
  } else {
    newQuote = new Quote({'content': req.body.content, 'id':quotecount});
  }
  newQuote.save(function (err, newQuote) {
    if (err) return console.error(err);
    res.json(quotecount);
  });;
});

router.route('/quotes/:id')
.get(function(req, res, next) {
    Quote.findOne({"id":req.params.id},
    function (err, result) {
        res.send(result);
    });
})
.put(function(req, res, next) {
  if(!req.body.hasOwnProperty('content') && (!req.body.hasOwnProperty('author'))) {
    res.statusCode = 400;
    return res.send('Error 400: Post syntax incorrect.');
  }
  var query = {'id':req.params.id};
  var newQuote = new Quote();
  if (req.body.hasOwnProperty('author')) {
        newQuote.author = req.body.author;
  };
  if (req.body.hasOwnProperty('content')) {
        newQuote.content = req.body.content;
  };
  var upsertData = newQuote.toObject();
  delete upsertData._id;
  Quote.findOneAndUpdate(query, upsertData, {upsert:true}, function(err, doc){
    if (err) return res.send(500, { error: err });
    return res.send("succesfully saved");
  });
})
.delete(function(req, res, next) {
   Quote.findOneAndRemove({"id":req.params.id},
    function (err, result) {
        if (!err) {
           res.json(true);
        }
    });
});

app.use('/api', router);

// index
app.get('/', function(req, res) {
  res.send('Hello world from express');
});

var server = app.listen(3000, function() {
  console.log('Express is listening to http://localhost:3000');
});

