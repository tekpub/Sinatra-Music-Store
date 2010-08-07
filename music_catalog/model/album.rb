require "mongo_mapper"

class Album
	include MongoMapper::Document

	key :original_id, Integer
	key :name, String
	key :price, Float
	key :slug, String

	belongs_to :artist
	belongs_to :genre
	many :tracks
	def thumb
		"/images/placeholder.gif"
	end
end
