class InspectionsController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource
	def new
		#@inspection = Inspection.new
    #authorize! :create, @inspection
	end
	
	def show
		#@inspection = Inspection.find(params[:id])
		@chat_messages = @inspection.chat_messages
		@artifacts = @inspection.artifacts
		store_location
	end

	def create

		@inspection = Inspection.new(params[:inspection])
		# @inspection.file = params[:inspection]
		if @inspection.save
			flash[:success] = "inspection created"
			redirect_to root_url
		else
			render 'new'
		end
	end 

end
