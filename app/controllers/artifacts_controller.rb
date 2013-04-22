class ArtifactsController < ApplicationController
	before_filter :signed_in_user
	
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
  		@artifact.uploaded_file = params[:artifact]

  		if @artifact.save
  			flash[:success] = "Artifact #{@artifact.name} uploaded"
  			redirect_to root_url
  		else
  			flash[:error] = "A problem occured, artifact can not be uploaded. Try once more"
  			render 'new'
  		end
  	end
end
