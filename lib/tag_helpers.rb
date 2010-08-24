require 'sinatra/base'
require 'rack'

module Sinatra
	module TagHelpers
		def image_tag(file, title = nil)
			"<img src = '#{file}' alt = '#{title || file}' />"	
		end
		def h(text)
			Rack::Utils.escape_html(text)
		end
		def link_to(text, url)
			"<a href = '#{url}'>#{h(text)}</a>"
		end
		def image_link_tag(img, url)
			"<a href = '#{url}'>#{image_tag(img)}</a>"
		end
	end
end
