class InspectionsController < ApplicationController
	before_filter :signed_in_user

	def new
		@inspection = Inspection.new
	end
	
	def show
		@inspection = Inspection.find(params[:id])
		@chat_messages = @inspection.chat_messages
		store_location
	end

	def create

		@inspection = Inspection.new(params[:inspection])
		# @inspection.file = params[:inspection]
		if @inspection.save
			flash[:success] = "inpection created"
			redirect_to root_url
		else
			render 'new'
		end
	end 
end
