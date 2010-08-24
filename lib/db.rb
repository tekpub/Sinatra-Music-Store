require 'sinatra/base'

module SinatraStore
	module Database
		def self.init_mongo
			if(ENV['RACK_ENV'] == 'production')
				MongoMapper.connection = Mongo::Connection.new("localhost")
				MongoMapper.database = "SinatraStore"
			elsif(ENV['RACK_ENV']  == 'test')
				MongoMapper.connection = Mongo::Connection.new("localhost")
				MongoMapper.database = "SinatraStoreTest"
			else
				MongoMapper.connection = Mongo::Connection.new("localhost")
				MongoMapper.database = "SinatraStore"
			end

		end
	end
end
