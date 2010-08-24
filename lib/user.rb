require 'sinatra/base'
require 'rack'
require 'bcrypt'

class User
	include MongoMapper::Document

  key :login, String, :index => true, :required => true, :unique => true
  key :crypted_password, String, :required => true
  key :auth_token, String
  key :last_login, DateTime, :required => true
  key :active, Boolean, :default => true

	validates_length_of :login, :minimum => 4
	validates_confirmation_of :password
	validates_length_of :password, :minimum => 6
	
	def self.get_current(token)
		User.find_by_auth_token(token)
	end

	def self.authenticate(login, password)
    found = User.find_by_login_and_active(login, true)
    if(found)
      if(found.authenticated?(secret))
        #they're authenticated
        found.last_login = Time.now
        found.create_auth_token(login)
        found.save
        return found
      else
        return nil
      end
    
    end		
	end
	def self.register(hash)
    new_user = User.new
    new_user.login = hash[:login]
    new_user.password = hash[:password]

    #setup login stuff
    new_user.create_auth_token(new_user.login)
    new_user.last_login = Time.now

		#save will return false if it doesn't work, but we
		#don't want a boolean here - return the full object
		#as it has model errors on it
		new_user.save
    new_user		
	end
	#the auth token is unique per user session
	#only one login allowed per key - so be sure to do a 
	#lookup with this key - NOT the login for the user
	def create_auth_token(key)
		self.auth_token = Digest::SHA1.hexdigest("#{random_string}--#{Time.now}---#{key}")
	end
	def random_string(size=18)
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }		
	end
  def password
    if crypted_password.present?
      @password ||= BCrypt::Password.new(crypted_password)
    else
      nil
    end
  end
  def authenticated?(secret)    
    password == secret ? true : false
  end

  def password= (value)
    if value.present?
      @password = value
      self.crypted_password = BCrypt::Password.create(value)
    end
  end	
	
end
