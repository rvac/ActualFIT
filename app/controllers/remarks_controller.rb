class RemarksController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource :inspection
  load_and_authorize_resource :remark, :through => :inspection

	respond_to :html, :js

	def create
    # we dont need this shit, since it is created in the view??
    #@inspection = current_inspection
    #@remark = current_user.remarks.build(params[:remark])

    #we don't know the id, so we
    @inspection = Inspection.find(params[:inspection_id])
    if params[:artifact_id] == ""
      params[:artifact_id] = nil
    elsif Artifact.find(params[:artifact_id])
      @remark.artifact_id = params[:artifact_id]
    end
    @remark.user_id = current_user.id
		if @remark.save
      flash.now[:success] ||= []
      #flash.now[:success] << "Yahoo, we did it"
			# respond_with root_url
		else
      flash.now[:error] ||= []
      @remark.errors.full_messages.each {|m| flash.now[:error] << m }
			# redirect_to root_url
    end
    #redirect_to root_url
	end

  def index
    @inspection = self.current_inspection
    if params[:after].empty?
      @remarks = @inspection.remarks
    else
      @remarks = @inspection.remarks.where("id > ?", params[:after].to_i) if params[:after].to_i > 0
    end
  end

  def destroy
		@remark = Remark.find(params[:id])
    #@inspection = current_inspection
		if @remark.destroy
      flash.now[:success] ||= []
      #flash.now[:success] << "Remark deleted"
		else
			flash.now[:error] ||= []
			flash.now[:error] << "Remark can not be deleted"
		end
	    # redirect_back_or root_url
	end

end
