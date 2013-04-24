class ChatMessagesController < ApplicationController
	before_filter :signed_in_user
	respond_to :html, :js
	
	def create
		@chat_message = current_user.chat_messages.build(params[:chat_message])

		if @chat_message.save
			# flash[:success] = "Yahoo, we did it"
			# respond_with root_url
		else
			flash.now[:error] = "Still troubling with chat message creation"
		end
	end
	def destroy
	end
end
