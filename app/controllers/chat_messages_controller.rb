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
    @inspection = Inspection.find(params[:inspection_id])
    if !@inspection.nil?
      @chat_message = @inspection.chat_messages.build(params[:chat_message])
      @chat_message.user_id = current_user.id
      if !@chat_message.save
        flash.now[:error] ||= []
        @chat_message.errors.full_messages.each {|m| flash.now[:error] << m}
      end
    end
  end


	def destroy
	end
end
