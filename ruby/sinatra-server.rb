require 'rubygems'
require 'sinatra'
require 'mongo'
require 'json/ext' # required for .to_json

configure do
  db = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')  
  set :mongo_db, db[:quotes]
end

before do
    content_type 'application/json'
end

set :port, 3000
get '/' do
  settings.mongo_db.find({},:sort=>['id'=> Mongo::Index::DESCENDING],:limit => 10).to_a.to_json
end
