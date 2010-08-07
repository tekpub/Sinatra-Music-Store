class Customer
  include MongoMapper::Document

  key :original_id, Integer
  key :login, String
  key :first_name, String
  key :last_name, String
  key :company, String
  key :email, String
  key :address, String
  key :city, String
  key :state, String
  key :country, String
  key :phone, String
  key :fax, String
  key :postal_code, String
 
 	many :cart_items

  timestamps!

	def self.find_or_create(login)
		Customer.find_by_login(login) or Customer.new(:login => login)
	end
	def add_item_to_cart(hash)
		found = self.cart_items.find_by_sku(hash[:sku])
		unless(found)
			ci = CartItem.create(hash)
			self.cart_items << ci
			self.save
		else
			found.quantity += hash[:quantity].to_i
			found.save
		end
		
	end
	def empty_cart
		self.cart_items.delete_all
		
	end
	def cart_total
		total = 0.0
		self.cart_items.each{|i| total += i.item_price}
		total
		
	end
	def cart_contains(sku)
		self.cart_items.find_by_sku(sku)
	end
	def remove_item_from_cart(sku)
		found = cart_contains(sku)
		if(found)
			self.cart_items.delete(found.id)
		end
		
	end
	def self.migrate_cart(from_login, to_login)
		from = Customer.find_by_login(from_login)
		to = Customer.find_by_login(to_login)
		if(from && to)
			to.empty_cart
			from.cart_items.each {|i| to.cart_items << i}
			from.empty_cart
			from.save
			to.save
		end
	end
end
