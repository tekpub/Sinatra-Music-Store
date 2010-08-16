require 'sinatra/base'

module Sinatra
	module TagHelpers
		def image_tag(file, title = nil)
			"<img src = '#{file}' alt = '#{title || file}' />"	
		end
	end
end
