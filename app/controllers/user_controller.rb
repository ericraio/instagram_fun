class UserController < ApplicationController
	before_filter :oauth
	respond_to :html, :js

	def index
		if ( @client && @ig_user )
			user_id = params[:id]

			if ( user_id )
				@view_user = @client.user( user_id )
			else
				@view_user = @ig_user
			end

			if ( @view_user )
				@title = "Instagram feed for #{@view_user.username}"

				if ( params[:max_id] )
					@photos  = @client.user_recent_media( @view_user.id, { :max_id => params[:max_id], :count => 10 } )
				else
					@photos  = @client.user_recent_media( @view_user.id, { :count => 10 } )
				end

				@first_id = @photos.first.id
				@last_id  = @photos.last.id

				logger.info( "Got #{@photos.size} photos" )
			else
				logger.error 'trying to view feed for nobody'
				redirect_to :controller => 'home', :action => 'index' and return false
			end
		else
			logger.error 'failed to get client'
			redirect_to :controller => 'home', :action => 'index' and return false
		end
	end
end
