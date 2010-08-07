class CartItem
	include MongoMapper::Document

	key :sku, String
	key :name, String
	key :item_price, Float
	key :quantity, Integer
	key :add_at, Time

	timestamps!

	belongs_to :customer
end
