require 'sinatra/base'

module Sinatra
	module Blacklister
		def block_blacklisted
			before do
				halt 403, "Backballed! #{request.ip}" if(BlockedIp.find_by_ip(request.ip))
			end
		end
		def blacklist(ip)
			BlockedIp.create!(:ip => ip)
		end
	end
end

class BlockedIp
	include MongoMapper::Document

	key :ip, String
	key :block_until, DateTime, :default => 100.years.from_now
end
