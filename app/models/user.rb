class User < ActiveRecord::Base
	def touch
		User.update( id, { :atime => Time.now } )
		reload
	end
end
