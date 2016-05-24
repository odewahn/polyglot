// *******************************************
// DATABASE STUFF ****************************
// *******************************************
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/test');
var db = mongoose.connection;

var quoteSchema = mongoose.Schema({
        content: String,
        author: String,
        index: Number
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

app.use('/demo', express.static(path.join(__dirname, '..', 'static')));
app.use(bodyParser.json());

// index
app.get('/', function(req, res) {
  res.send('Hello world from express');
});
app.use('/api', router);

// REST API
router.route('/quotes/random')
.get(function(req, res, next) {
    var random = Math.floor(Math.random() * quotecount);
    Quote.findOne({"index":random},
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
   var result = Quote.find().sort({'index': -1}).limit(10);
   result.exec(function(err, quotes) {
	res.send(quotes);
});
})
.post(function(req, res, next) {
  if(!req.body.hasOwnProperty('content')) {
    return res.status(400).send('Error 400: Post syntax incorrect.');
  }
  quotecount = quotecount+1; 
  var newQuote;
  if (req.body.hasOwnProperty('author')) {
    newQuote = new Quote({'content': req.body.content, 'author': req.body.author, 'index': quotecount});
  } else {
    newQuote = new Quote({'content': req.body.content, 'index':quotecount});
  }
  newQuote.save(function (err, newQuote) {
    if (err) return console.error(err);
    res.json(quotecount);
  });;
});

router.route('/quotes/:index')
.get(function(req, res, next) {
    Quote.findOne({"index":req.params.index},
    function (err, result) {
        res.send(result);
    });
})
.put(function(req, res, next) {
  if(!req.body.hasOwnProperty('content') && (!req.body.hasOwnProperty('author'))) {
    return res.status(400).send('Error 400: Post syntax incorrect.');
  }
  var query = {'index':req.params.index};
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
    res.setHeader('Content-Type', 'application/json');
    return res.status(202).send(req.params.index);
  });
})
.delete(function(req, res, next) {
   Quote.findOneAndRemove({"index":req.params.index},
    function (err, result) {
        if (!err) {
           res.json(true);
        }
    });
});


var server = app.listen(3000, "0.0.0.0", function() {
  console.log('Express is listening to http://localhost:3000');
});

