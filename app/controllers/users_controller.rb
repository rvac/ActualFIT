class UsersController < ApplicationController
	before_filter   :signed_in_user, only: [:edit, :update]
	before_filter   :correct_user, only: [:edit, :update]

	def new
		@user = User.new
	end
	def show
		@user = User.find(params[:id])
		@chat_messages = @user.chat_messages
	end
	def create
		@user = User.new(params[:user])
		if @user.save
	    	sign_in @user
			flash[:success] = "Welcome aboard!"
			redirect_to root_url
			# redirect_to current_user(@user)

		else

			render 'new'
		end
	end

	def edit
	 # @user = User.find(params[:id])
	end

	# Function to be modified. Taken from SAMPLEAPP
	def update
	  # @user = User.find(params[:id])
	  # if @user.update_attributes(params[:user])
	  #   #handle a successful update
	  #   flash[:success] = "Profile updated"
	  #   sign_in @user
	  #   redirect_to @user
	  # else
	  #   render 'edit'
	  # end
	end

	private

		def signed_in_user
		  unless signed_in?
		  	store_location
			redirect_to signin_url, notice: "Please sign in"
		  end
		end
		
		def correct_user
		@user = User.find(params[:id])
		redirect_to (root_path) unless current_user?(@user)

		end
end
