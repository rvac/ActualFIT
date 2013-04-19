class MainPageController < ApplicationController
  def home
  		if signed_in?
  			#do nothing be happy
  			# @user = User.find(params[:id])
  			# @chat_messages = @user.chat_messages
  		else
  			redirect_to signup_url
  		end	
  end
end
