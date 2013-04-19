class ChatMessagesController < ApplicationController
	before_filter :signed_in_user

	def create
		@chat_message = current_user.chat_messages.build(params[:chat_message])
		if @chat_message.save
			# flash[:success] = "Yahoo, we did it"
			redirect_to root_url
		else
			flash[:error] = "Still troubling with chat message creation"
			redirect_to root_url
		end
	end
	def destroy
	end
end
