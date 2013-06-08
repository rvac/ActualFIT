class ArtifactsController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource
	#respond_to :html, :js

  def new
    @artifact = Artifacts.new
  end


  def create
    redirect_back_or root_url if params[:artifact].blank?
    @artifact.inspection_id = current_inspection.id
    @artifact.user_id = current_user.id
    if @artifact.save
      flash[:success] = "Artifact #{@artifact.name} uploaded"
      redirect_back_or root_url
    else
      flash.now[:error] = "Artifact #{@artifact.name} was not uploaded. Try again"
      render 'new'
    end
  end

  def show
    @artifact = Artifact.find(params[:id])
    send_data @artifact.file, filename: @artifact.filename,
    type: @artifact.content_type
  end

  def index
    @artifacts = Artifact.all
    #only admins have right to look here
    # group by campaign, that by inspection
  end

  def edit
    @artifact = Artifact.find(params[:id])
  end

  def update
    #here and update happens. Probably some popup/modal, that says that we can edit name, comments or change the file itself
    @artifact = Artifact.find(params[:id])
    incoming_file = params[:artifact][:datafile]
    # @uploaded_file = incoming_file
    if !incoming_file.nil?
      @artifact.filename = incoming_file.original_filename
      @artifact.content_type = incoming_file.content_type
      @artifact.file = incoming_file.read
    end


    if params[:artifact][:name].empty?
      @artifact.name = @artifact.filename
    else
      @artifact.name = params[:artifact][:name]
    end
    @artifact.comment = params[:artifact][:comment]

    @artifact.inspection_id = 1 #current_inspection
    if @artifact.save
      flash[:success] = "Artifact #{@artifact.name} edited"
      redirect_back_or root_url
    else
      flash[:error] = "A problem occured, artifact can not be edited. Try once more"
      render 'edit'
    end
  end


  def destroy
      @artifact = Artifact.find(params[:id])
      if @artifact.destroy
        flash[:notice] = "Artifact was deleted"
      else
        flash[:alert] = "Artifact can not be deleted"
      end
      redirect_back_or root_url
  end

 #  	def download_all
 #  		params[:ids].each do |id|
 #  	  		@artifact = Artifact.find(id)
 #  	  		send_data @artifact.file, filename: @artifact.filename,
	# 				 type: @artifact.content_type
	# 	end
	# end
end
