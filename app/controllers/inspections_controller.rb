class InspectionsController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource


	def new
		@inspection = Inspection.new
    #authorize! :create, @inspection
	end

  def download_artifacts
    @inspection = Inspection.find(params[:id])
    @inspection.artifacts.each do |a|
      send_data a.file, filename: a.filename,
                type: a.content_type
    end

  end

	def show
		@inspection = Inspection.find(params[:id])
    self.current_inspection= @inspection
		store_location
	end

	def create


		if @inspection.save
			flash[:success] = "inspection #{@inspection.name} created"
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
