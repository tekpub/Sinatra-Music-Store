module Sinatra
	module Authorization
		def logged_in?
			request.cookies[:auth].present?
		end

		def is_admin?
			return false if current_user.nil?
			current_user.login == "tekpub"
		end

		def current_user
			return User.new unless logged_in?
			User.get_current(request.cookies[:auth])
		end

		def protect!
			session[:return_to] = request.url
			redirect_back_or_default("/login") unless logged_in?
		end

		def admin_only!
			session[:return_to] = request.url
			redirect_back_or_default("/login") unless is_admin?
		end

		def redirect_back_or_default(url=nil)
      redirect(url || session[:return_to] )
      session[:return_to] = nil
		end
		def self.registered(app)
			app.helpers Authorization

			app.get "/login" do
				haml :login
			end
		end
	end
end
