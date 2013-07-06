class ChatMessagesController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource :inspection
  load_and_authorize_resource :ChatMessage, :through => :inspection
	respond_to :html, :js


  def index
    @inspection = self.current_inspection
    if params[:after].empty?
        @chat_messages = @inspection.chat_messages
    else
        @chat_messages = @inspection.chat_messages.where("id > ?", params[:after].to_i) if params[:after].to_i > 0
    end
  end

	def create
    @inspection = current_inspection
    @chat_message = @inspection.chat_messages.build(params[:chat_message])
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
