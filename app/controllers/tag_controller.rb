class TagController < ApplicationController
	before_filter :oauth
	respond_to :html, :js

	def index
		if ( @client && @ig_user )
			@tag = params[:tag].gsub( /\s+/, '_' ).strip.downcase
			
			unless ( @tag.blank? )
				@title = "Instagram feed for tag #{@tag}"

				if ( params[:max_id] )
					resp = @client.tag_recent_media( @tag, { :max_id => params[:max_id], :count => 10 } )
				else
					resp = @client.tag_recent_media( @tag )
				end

				@photos = resp.data

				@first_id = @photos.first.id
				@last_id  = resp.pagination.next_max_tag_id
			else
				logger.error 'missing tag'
				redirect_to :controller => 'home', :action => 'index' and return false
			end
		else
			logger.error 'failed to get client'
			redirect_to :controller => 'home', :action => 'index' and return false
		end
	end
end
