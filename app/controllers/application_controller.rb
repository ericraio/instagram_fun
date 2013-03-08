class ApplicationController < ActionController::Base

	require 'zlib'
	require 'stringio'

	#before_filter :setCharset
	before_filter :preProcess

	after_filter :postProcess

	protect_from_forgery

	#def setCharset
	#	headers["Content-Type"] = "text/html; charset=utf-8"
	#end

	def preProcess
		@domain = 'whalin.com'
	end

	def postProcess
		headers['P3P'] = 'CP="CAO DSP LAW CUR DEVa TAIa PSAi PSDi OTPi OUR IND UNI NAV DEM STA LOC OTC"'
	end

	def checkAuth
		id = session[:user]

		if ( !id.blank? )
			reset_session

			begin
				@user = User.find( id )
				@user.touch
				@client = Instagram.client( :access_token => @user.token )

				if ( @client )
					@ig_user = @client.user
					if ( @ig_user )
						session[:user] = @user.id
					else
						logger.error "unable to get client for user #{@user.id}"
					end
				else
					logger.error "unable to get client for user #{@user.id}"
				end
			rescue
				logger.info "unknown user for id: #{id}"
			end
		end

		return ( @user )
	end

	def oauth
		unless ( checkAuth )
			redirect_to :controller => 'oauth', :action => 'index' and return false
		end
	end
end
