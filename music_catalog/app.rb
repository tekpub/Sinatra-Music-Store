require "rubygems"
require "sinatra/base"
require "mongo_mapper"
require "lib/tag_helpers"

class MusicCatalog < Sinatra::Base
	
	configure :development do
		MongoMapper.connection = Mongo::Connection.new("localhost")
		MongoMapper.database = "SinatraStore"
	end
	helpers Sinatra::TagHelpers
	helpers do
		def album_url(album)
			"/#{album.artist.slug}/#{album.slug}"
		end
	end
	before do
		@genres = Genre.all
	end	
	not_found do
		haml :not_found
	end
	get "/" do
		haml :index
	end
	get "/:genre.:format" do
		@genre = Genre.find_by_slug(params[:genre])
		format = params[:format]
		if(format == "xml")
			@genre.albums.to_xml
		elsif(format == "json")
			@genre.albums.to_json
		else
			#?????
			#pass along the request to the next match...
			redirect "/#{params[:genre]}"
		end
	end
	get "/:genre" do
		@genre = Genre.find_by_slug(params[:genre])
		haml :genre
	end

	get "/:artist/:album" do
		@artist = Artist.find_by_slug(params[:artist])
		@album = Album.find_by_artist_id_and_slug(@artist.id, params[:album])
		pass if @album.nil?
		haml :album
	end
end
