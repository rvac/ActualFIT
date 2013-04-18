class MainPageController < ApplicationController
  def home
  		if signed_in?
  			#do nothing be happy
  		else
  			redirect_to signup_url
  		end	
  end
end
