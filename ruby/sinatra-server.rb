require 'rubygems'
require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'
require 'mongo'
require 'json/ext' # required for .to_json

class Quote
  include Mongoid::Document
  field :index
  field :author
  field :content
end
Mongoid.load!("mongoid.yml", :development)
set :port, 3000
set :bind, '0.0.0.0'

get '/demo*' do
  content_type :html
  File.read(File.join('../static', 'index.html'))
end

get '/' do
  content_type :html
  "Hello World from Sinatra"
end

before do
  content_type 'application/json'
end

  namespace "/api" do
     # list all
    get '/quotes' do
      Quote.all.desc(:index).limit(10).to_json
    end

    get '/quotes/random' do
      newnumber = Quote.count
      random_num = rand(newnumber)
      quote = Quote.find_by(index: random_num.to_i)
      return status 404 if quote.nil?
      quote.to_json
    end

    # view one
    get '/quotes/:index' do
      quote = Quote.find_by(index: params[:index].to_i)
      return status 404 if quote.nil?
      quote.to_json
    end

    # create
    post '/quotes' do
      newnumber = Quote.count + 1
      @json = JSON.parse(request.body.read)
      quote = Quote.new(
                        content: @json['content'], 
                        author: @json['author'], 
                        index: newnumber)
      quote.save
      status 201
      body = newnumber
    end

    # update
    put '/quotes/:index' do
      @json = JSON.parse(request.body.read)
      quote = Quote.find_by(index: params[:index].to_i)
      return status 404 if quote.nil?
      quote.update(
                        content: @json['content'], 
                        author: @json['author']
                  )
      quote.save
      status 202
    end

    delete '/quotes/:index' do
      quote = Quote.find_by(index: params[:index].to_i)
      return status 404 if quote.nil?
      quote.delete
      status 204
    end
  end
