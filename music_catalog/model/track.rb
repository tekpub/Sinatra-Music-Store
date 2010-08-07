require "mongo_mapper"

class Track
	include MongoMapper::Document
	
	key :original_id, Integer
  key :name, String
  key :composer, String
  key :milliseconds, Integer
  key :bytes, Integer
  key :unit_price, Float

  belongs_to :album
	belongs_to :genre
	
end
