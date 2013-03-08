class OauthController < ApplicationController

	require "rubygems"
	require "instagram"

	CLIENT_ID     = '57ff2ca02d0f406e9ae2afb64797174c'
	CLIENT_SECRET = 'f6bf1d8df45547d5ad39a11eb6a16907'

	def index
		if ( session[:logout] )
			logger.info "logging this user out"
			@logout = true
			reset_session
		elsif ( checkAuth )
				logger.info "already logged in as #{@user.id}"
				redirect_to :controller => 'home' and return false
		end
	end

	def connect
		Instagram.configure do |config|
			config.client_id = CLIENT_ID
			config.client_secret = CLIENT_SECRET
		end

		callback_url = url_for :controller => 'oauth', :action => 'callback'
		logger.info "sending to ig url for oauth: #{Instagram.authorize_url( :redirect_uri => callback_url )}"
		redirect_to Instagram.authorize_url( :redirect_uri => callback_url )
	end

	def callback
		callback_url = url_for(:controller => 'oauth', :action => 'callback')
		@response = Instagram.get_access_token(params[:code], :redirect_uri => callback_url)
		token = @response.access_token
    @client = Instagram.client(:access_token => token)

    if @response && @response.user && token
      @user = User.find_or_create_by_token(:token => token)
      if @user
        user_params = @response.user.to_hash.merge!(@client.user.counts.to_hash)
        @user.update_attributes(user_params)
        session[:user] = @user.id
      end
    end

		redirect_to root_path(:token => token)
	end
end
