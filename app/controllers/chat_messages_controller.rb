class ChatMessagesController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource
	respond_to :html, :js


  def index
    @inspection = self.current_inspection
    @chat_messages = @inspection.chat_messages
    i = 0
  end

	def create
		@chat_message = current_inspection.chat_messages.build(params[:chat_message])
    @inspection = current_inspection
    @chat_message.user_id = current_user.id
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
