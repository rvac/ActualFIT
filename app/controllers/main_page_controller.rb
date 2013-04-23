class MainPageController < ApplicationController
  def home
  		if signed_in?
  			#Get current-inspection - redirect to it
  			# @user = User.find(params[:id])
  			# @chat_messages = @user.chat_messages
  			redirect_to current_user
  		else
  			redirect_to signup_url
  		end	
  end
end
