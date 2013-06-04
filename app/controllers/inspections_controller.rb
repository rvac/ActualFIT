class InspectionsController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource
	def new
		#@inspection = Inspection.new
    #authorize! :create, @inspection
	end
	
	def show
		@inspection = Inspection.find(params[:id])
    #@current_inspection = @inspection
		@chat_messages = @inspection.chat_messages
		@artifacts = @inspection.artifacts
    @remarks = @inspection.remarks
		store_location
	end

	def create

		@inspection = Inspection.new(params[:inspection])
    @inspection.active!
    #@current_inspection = @inspection
		# @inspection.file = params[:inspection]
		if @inspection.save
			flash[:success] = "inspection created"
			redirect_to root_url
		else
			render 'new'
		end
  end


  #def refresh_chat
  #  @inspection = Inspection.find(params[:id])
  #  respond_to do |format|
  #    format.js
  #  end
  #end

  def destroy
    #remove a roles connected to inspections when deleted
  end

end
