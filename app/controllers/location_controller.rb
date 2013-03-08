class LocationController < ApplicationController
	before_filter :oauth

	def index
		if ( @client && @ig_user )
			location_id = params[:id]

			if ( location_id )
				@location = @client.location( params[:id] )
			end

			if ( @location )
				@title = "Instagram feed for #{@location.name}"

				if ( params[:max_id] )
					@photos  = @client.location_recent_media( @location.id, { :max_id => params[:max_id], :count => 10 } ).data
				else
					@photos  = @client.location_recent_media( @location.id, { :count => 10 } ).data
				end

				@first_id = @photos.first.id
				@last_id  = @photos.last.id

				logger.info( "Got #{@photos.size} photos" )
			else
				logger.error 'trying to view feed for missing location'
				redirect_to :controller => 'home', :action => 'index' and return false
			end
		else
			logger.error 'failed to get client'
			redirect_to :controller => 'home', :action => 'index' and return false
		end
	end
end
