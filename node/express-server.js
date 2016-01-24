var express = require('express');
var app = express();
var router = express.Router();    

var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/test');
var db = mongoose.connection;


var quoteSchema = mongoose.Schema({
        name: String,
        author: String,
        id: Number
});

var quotecount;
var Quote = mongoose.model('Quote', quoteSchema)
Quote.count().exec(function(err, count){
   quotecount = count;
});


// REST API
router.route('/quotes')
.get(function(req, res, next) {
  if (req.query.random) {
    var random = Math.floor(Math.random() * quotecount);
    Quote.findOne({"id":random},
    function (err, result) {
	res.send(result);
    });
  } else {
    Quote.find(
      function (err, result) {
         res.send(result);
      }
   )};
})
.post(function(req, res, next) {
  res.send('Post');
});

router.route('/quotes/:id')
.get(function(req, res, next) {
    Quote.findOne({"id":req.params.id},
    function (err, result) {
        res.send(result);
    });
})
.put(function(req, res, next) {
  res.send('Put id: ' + req.params.id);
})
.delete(function(req, res, next) {
  res.send('Delete id: ' + req.params.id);
});

app.use('/api', router);

// index
app.get('/', function(req, res) {
  res.send('Hello world');
});

var server = app.listen(3000, function() {
  console.log('Express is listening to http://localhost:3000');
});
