class PhotoController < ApplicationController
	before_filter :oauth

	def index
		if ( !params[:id].blank? )
			if ( @client && @ig_user )
				@photo    = @client.media_item( params[:id] )
				@likes    = @client.media_likes( params[:id] )
				@comments = @client.media_comments( params[:id] )
				@title = "Instagram photo"
			else
				logger.error 'failed to get client'
			end
		end
	end
end
