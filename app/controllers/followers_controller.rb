class FollowersController < ApplicationController
	before_filter :oauth

	def index
		if ( @client && @ig_user )
			user_id = params[:id]

			if ( user_id )
				@view_user = @client.user( user_id )
			else
				@view_user = @ig_user
			end

			if ( @view_user )
				@users = @client.user_followed_by( @view_user.id )
				@title = "#{@view_user.username} is followed by"
			else
				logger.error 'trying to view feed for nobody'
				redirect_to :controller => 'home', :action => 'index' and return false
			end
		else
			logger.error 'failed to get client'
		end
	end
end
