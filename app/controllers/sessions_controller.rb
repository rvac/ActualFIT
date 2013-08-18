class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	if user && user.authenticate(params[:password])
  		sign_in user
  		#if current_inspection.nil?
        redirect_to user
      #else
      #  redirect_to current_inspection
      #end
    else
      flash.now[:error] ||= []
  		flash.now[:error] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	sign_out
  	redirect_to signin_url
  end
end
