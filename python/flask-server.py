from flask import Flask, jsonify, Response, send_from_directory
from flask_restful import reqparse, abort, Api, Resource
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps, default
import os
from random import randint

app = Flask("test",static_folder='')
api = Api(app)
mongo = PyMongo(app)


parser = reqparse.RequestParser()
parser.add_argument('author')
parser.add_argument('content', required=True,
help="Content cannot be blank!")

APP_ROOT = os.path.dirname(os.path.abspath(__file__))
STATIC_ROOT = os.path.join(APP_ROOT, "..", "static")

class Quote(Resource):
    def get(self, quote_id):
        if quote_id == "random":
	    print "Random is random"
            quotes = mongo.db.quotes.find().sort("index", -1).limit(1)
            max_number = int(quotes[0]["index"])
            rand_quote = randint(0, max_number)
            quotes = mongo.db.quotes.find_one({"index": int(rand_quote)})
        else:
            quotes = mongo.db.quotes.find_one({"index": int(quote_id)})
        resp = Response(dumps(quotes, default=default),
                mimetype='application/json')
        return resp

    def delete(self, quote_id):
        print "Quote id is %s" % quote_id
        try:
            mongo.db.quotes.remove({
                'index': int(quote_id)
            })
        except Exception as ve:
            print ve
            abort(400, str(ve))
        return '', 204

    def put(self, quote_id):
        args = parser.parse_args()
        if not (args['content'] or args['author']):
            return 'Missing data', 400
        existing_quote = mongo.db.quotes.find_one({"index": int(quote_id)})
        args['content'] = args['content'] if args['content'] else existing_quote["content"]
        args['author'] = args['author'] if args['author'] else existing_quote["author"]
        try:
            mongo.db.quotes.update({
                'index': int(quote_id)
            },{
                '$set': {
                    'content': args['content'],
                    'author': args['author']
            }
        }, upsert=False)
        except Exception as ve:
            print ve
            abort(400, str(ve))
        return 201


# TodoList
# shows a list of all todos, and lets you POST to add new tasks
class QuoteList(Resource):
    def get(self):
        quotes = mongo.db.quotes.find().sort("index", -1).limit(10)
        resp = Response(dumps(quotes, default=default),
                mimetype='application/json')
        return resp

    def post(self):
        args = parser.parse_args()
        quotes = mongo.db.quotes.find().sort("index", -1).limit(1)
        print quotes[0]
        args["index"] = int(quotes[0]["index"]) + 1
        print args
        try:
            mongo.db.quotes.insert(args)
        except Error as ve:
            abort(400, str(ve))

        return 201

@app.route('/')
def hello_world():
    return 'Hello from Flask!'


@app.route('/demo')
def serve_page():
    return send_from_directory(STATIC_ROOT, "index.html")

api.add_resource(QuoteList, '/api/quotes')
api.add_resource(Quote, '/api/quotes/<quote_id>')


if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=3000)
