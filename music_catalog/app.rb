require "rubygems"
require "sinatra/base"
require "mongo_mapper"
require "lib/tag_helpers"
require "sinatra_more"
require "lib/db"
require "lib/auth"
require "lib/blacklist"
require "lib/logging"

class MusicCatalog < Sinatra::Base

	register SinatraMore::RoutingPlugin
	register SinatraMore::MarkupPlugin
	register Sinatra::Authorization
	register Sinatra::Blacklister
	register Sinatra::Logging

	configure do
		SinatraStore::Database.init_mongo
	end

	#mapping
	map(:genre).to("/:genre")
	map(:album).to("/:artist/:album")

	before do
		@genres = Genre.all
	end	

	not_found do
		haml :not_found
	end

	get "/" do
		info "viewing home page"
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
			redirect "/#{params[:genre]}"
		end
	end

	get :genre do
		@genre = Genre.find_by_slug(params[:genre])
		haml :genre
	end

	get :album do
		@artist = Artist.find_by_slug(params[:artist])
		@album = Album.find_by_artist_id_and_slug(@artist.id, params[:album])
		pass if @album.nil?
		haml :album
	end
end
