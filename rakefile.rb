require 'rubygems'
require 'mongo_mapper'
require 'nokogiri'
require 'music_catalog/model/artist'
require 'music_catalog/model/album'
require 'music_catalog/model/genre'
require 'music_catalog/model/track'
require 'customer/model/customer'

def open_xml
	f = File.open("db/chinook.xml")
	@doc = Nokogiri::XML(f)
end
def init_mongo
	MongoMapper.connection = Mongo::Connection.new("localhost")
	MongoMapper.database = "SinatraStore"
end
def init_model
  Artist.delete_all
  Track.delete_all
  Genre.delete_all
  Album.delete_all
end
def parse_key(key, &block)
	items = @doc.css(key)
	items.each do |item|
		def item.method_missing(meth, *args)
			found = self.at_css(meth.to_s)
			raise "Can't find #{meth}" if found.nil?
			found.content
		end
		yield(item)
	end
end

def sluggify(title)
	title.downcase.gsub(" ","-").gsub("&","-n-").gsub("/","-").gsub(",","")	
end

def load_genres
	parse_key("Genre") do |item|
		 thing = Genre.create!(:name => item.Name,
								        :original_id => item.GenreId.to_i,
													:slug => sluggify(item.Name))

		 puts "#{thing.name} created..."
	end
end
def load_customers
		parse_key("Customer") do |item|
    		thing = Customer.create!(:original_id => item.CustomerId.to_i,
                         :first_name => item.FirstName,
                         :last_name => item.LastName,
                         :company => item.Company,
                         :email =>item.Email,
                         :address => item.Address,
                         :city => item.City,
                         :state => item.State,
                         :country => item.Country,
                         :phone => item.Phone,
                         :fax => item.Fax,
                         :postal_code => item.PostalCode)
				
				puts "#{thing.first_name} #{thing.last_name} created..."
		end

end
def load_artists
	parse_key("Artist") do |item|
    thing = Artist.create!(:name => item.Name, 
                            :original_id => item.ArtistId.to_i,
													:slug => sluggify(item.Name))
    puts " - #{thing.name}"
	end
end

def load_albums
	parse_key("Album") do |item|
    thing = Album.create!(:name => item.Title, 
                          :original_id => item.AlbumId.to_i,
												 :slug => sluggify(item.Title))
    puts " - #{thing.name}"
	end
end
def load_tracks
	parse_key("Track") do |item|
    thing = Track.create!(:name => item.Name, 
													:composer => item.Composer,
													:milliseconds => item.Milliseconds.to_i,
													:bytes => item.Bytes.to_i,
													:unit_price => item.UnitPrice.to_f,
                          :original_id => item.TrackId.to_i)
    puts " - #{thing.name}"
	end	
end
def associate	
	parse_key("Track") do |item|
		track = Track.find_by_original_id(item.TrackId.to_i)
		album = Album.find_by_original_id(item.AlbumId.to_i)
		genre = Genre.find_by_original_id(item.GenreId.to_i)
		puts "... adding #{track.name} to #{album.name} and setting to #{genre.name}"
		album.tracks << track
		album.genre = genre
		album.price = 8.99
		album.save		
	end
	parse_key("Album") do |item|

		album = Album.find_by_original_id(item.AlbumId.to_i)
		artist = Artist.find_by_original_id(item.ArtistId.to_i)
		puts "... setting #{album.name} artist to #{artist.name}"
		artist.albums << album
		artist.save
	end


end
desc "import music catalog"
task :import_catalog do

	puts "Opening xml file.."
	open_xml

	puts "Connecting to MongoDb..."
	init_mongo

	puts "Deleting existing.."
	init_model
	
	load_genres
	load_albums
	load_artists
	load_tracks
	associate
end
desc "import customers"
task :import_customers do

	puts "Opening xml file.."
	open_xml

	puts "Connecting to MongoDb..."
	init_mongo

	puts "Deleting existing.."
	Customer.delete_all
	
	load_customers
end

