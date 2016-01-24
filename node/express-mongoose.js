var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/test');
var db = mongoose.connection;


var quoteSchema = mongoose.Schema({
	name: String,
	author: String,
	id: Number
});

var Quote = mongoose.model('Quote', quoteSchema)
//var number = db.quotes.stats();;
//console.log(number);
//db.quotes.find().limit(-1).skip(db.quotes.count).next()



Quote.count().exec(function(err, count){
  var random = Math.floor(Math.random() * count);
  Quote.findOne({"id":random},
    function (err, result) {
	console.log(result.toString());
	console.log(result.name);
  });
});
