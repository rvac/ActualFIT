class ArtifactsController < ApplicationController
	before_filter :signed_in_user
	respond_to :html, :js

	def new
		@artifact = Artifact.new
	end

	def show
		@artifact = Artifact.find(params[:id])
		send_data @artifact.file, filename: @artifact.filename,
					 type: @artifact.content_type
	end

	def create
		return if params[:artifact].blank?

		@artifact = Artifact.new
		incoming_file = params[:artifact][:datafile]
		# @uploaded_file = incoming_file 
		@artifact.filename = incoming_file.original_filename
	  	@artifact.content_type = incoming_file.content_type
	  	@artifact.name = params[:artifact][:name]
	  	@artifact.file = incoming_file.read
	  	@artifact.inspection_id = 1
		if @artifact.save
			flash[:success] = "Artifact #{@artifact.name} uploaded"
			redirect_to root_url
		else
			flash[:error] = "A problem occured, artifact can not be uploaded. Try once more"
			render 'new'
		end
	end

  def destroy
      @artifact = Artifact.find(params[:id])
      if @artifact.destroy
        flash[:notice] = "Artifact was deleted"
      else
        flash[:alert] = "Artifact can not be deleted"
      end
      redirect_to root_url
  end


  def update
    #here and update happens. Probably some popup/modal, that says that we can edit name, comments or change the file itself
  end
end
