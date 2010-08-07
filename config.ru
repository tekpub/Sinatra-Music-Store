require "rubygems"
require "music_catalog/app"
require 'music_catalog/model/artist'
require 'music_catalog/model/album'
require 'music_catalog/model/genre'
require 'music_catalog/model/track'

require "customer/app"
require "customer/model/customer"
require "customer/model/cart_item"

map "/" do
	run MusicCatalog
end

map "/customer" do
	run CustomerApp
end
