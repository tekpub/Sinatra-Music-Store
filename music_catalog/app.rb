require "rubygems"
require "sinatra/base"

class MusicCatalog < Sinatra::Base
	get "/" do
		haml :index
	end
end
