require "rubygems"
require "sinatra/base"
require "mongo_mapper"

class CustomerApp < Sinatra::Base

	post "/add_item" do
		id = params[:album_id]
		album = Album.find(id)
		
		unless(album.nil?)
			login = @env['REMOTE_ADDR']
			customer = Customer.find_or_create(login)
			customer.add_item_to_cart(:sku => album.original_id,
																:item_price => album.price,
																:name => album.name,
																:quantity => 1)
			customer.save
			"Thanks! Added"
		end
	end

end
