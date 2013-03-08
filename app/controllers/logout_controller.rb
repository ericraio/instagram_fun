class LogoutController < ApplicationController
	def index
		session[:user] = nil
		session[:logout] = true
		redirect_to :controller => 'home' and return false
	end
end
