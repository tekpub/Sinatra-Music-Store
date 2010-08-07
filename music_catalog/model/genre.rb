require "mongo_mapper"

class Genre

	include MongoMapper::Document

	key :original_id, Integer
	key :name, String
	key :slug, String
	many :albums
end
