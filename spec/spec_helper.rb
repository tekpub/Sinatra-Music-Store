require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'
require 'mongo_mapper'
require 'music_catalog/app'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

MongoMapper.connection = Mongo::Connection.new('localhost')
MongoMapper.database = "SinatraStoreTest"  

