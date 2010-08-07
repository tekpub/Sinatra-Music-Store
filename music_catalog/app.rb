require "rubygems"
require "sinatra/base"
require "mongo_mapper"

class MusicCatalog < Sinatra::Base
	
	configure :development do
		MongoMapper.connection = Mongo::Connection.new("localhost")
		MongoMapper.database = "SinatraStore"
	end
	before do
		@genres = Genre.all
	end	
	get "/" do
		haml :index
	end

	get "/:genre" do
		@genre = Genre.find_by_slug(params[:genre])
		haml :genre
	end

	get "/:artist/:album" do
		@artist = Artist.find_by_slug(params[:artist])
		@album = Album.find_by_artist_id_and_slug(@artist.id, params[:album])
		haml :album
	end
end
