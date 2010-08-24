require "rubygems"
require "music_catalog/app"
require 'music_catalog/model/artist'
require 'music_catalog/model/album'
require 'music_catalog/model/genre'
require 'music_catalog/model/track'

require "customer/app"
require "customer/model/customer"
require "customer/model/cart_item"
require "lib/routes"
require "lib/db"
require "lib/user"
require "lib/blacklist"

map SinatraStore::Routes.store_root do
	run MusicCatalog
end

map SinatraStore::Routes.customer_root do
	run CustomerApp 
end
