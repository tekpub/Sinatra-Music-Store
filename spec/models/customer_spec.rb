require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "customer/model/customer"
require "customer/model/cart_item"

describe "Customer Retrieval" do
	
	before :all do
		Customer.delete_all
		CartItem.delete_all
	end

	it 'should create a customer when email not found' do
		customer = Customer.find_or_create('test')
		customer.should_not be nil 
	end

	it 'should return existing user' do
		Customer.create!(:login => "existing")
		customer = Customer.find_or_create('existing')
		customer.should_not be nil
	end

end

describe "Shopping Cart" do
  it 'should add new sku to cart items' do
		c = Customer.find_or_create("test")
		c.add_item_to_cart(:sku => "test",
											 :name => "test item",
											 :quantity => 1,
											 :item_price => 12.00)
		c.cart_items.count.should == 1
  end

  it 'should total up the cart items' do

		c = Customer.find_or_create("test")
		c.add_item_to_cart(:sku => "test",
											 :name => "test item",
											 :quantity => 1,
											 :item_price => 12.00)
		c.cart_total.should == 12.0
  end
  

  it 'should increment quantity when adding same sku' do

		c = Customer.find_or_create("test")
		2.times do
			c.add_item_to_cart(:sku => "test",
												 :name => "test item",
												 :quantity => 1,
												 :item_price => 12.00)
			c.cart_total.should == 12.0
		end
		c.cart_items.count.should == 1
  end

  it 'should clear items' do
			c = Customer.find_or_create("test")
			c.add_item_to_cart(:sku => "test",
												 :name => "test item",
												 :quantity => 1,
												 :item_price => 12.00)
			c.empty_cart
			c.cart_items.count.should == 0
  end

  it 'should let me know if cart item exists' do
			c = Customer.find_or_create("test")
			c.add_item_to_cart(:sku => "test",
												 :name => "test item",
												 :quantity => 1,
												 :item_price => 12.00)
			c.cart_contains("test").should_not be nil
  end
  
  it 'should remove items' do

			c = Customer.find_or_create("test")
			c.add_item_to_cart(:sku => "test",
												 :name => "test item",
												 :quantity => 1,
												 :item_price => 12.00)
			c.remove_item_from_cart("test")
			c.cart_contains("test").should be nil
  end

  it 'should migrate from one user to another - replacing items' do
		c1 = Customer.find_or_create("test5")
		c1.add_item_to_cart(:sku => "sku",
									:item_price => 12.0,
									:quantity => 1,
									:name => "Test Product")
		c2 = Customer.find_or_create("test6")
		c2.add_item_to_cart(:sku => "sku",
									:item_price => 12.0,
									:quantity => 1,
									:name => "Test Product")

		Customer.migrate_cart("test5","test6")
		c1.cart_items.count.should be 0
		c2.cart_items.count.should be 1

  end
	
end
