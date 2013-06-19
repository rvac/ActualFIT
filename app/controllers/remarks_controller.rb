class RemarksController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource
	respond_to :html, :js
	
	def create
		@remark = current_user.remarks.build(params[:remark])
    @inspection = current_inspection
    @remark.inspection_id = @inspection.id
		if @remark.save
			# flash[:success] = "Yahoo, we did it"
			# respond_with root_url
		else
			flash.now[:error] = "Still troubling with remark creation"
			# redirect_to root_url
		end
	end

  def index
    @inspection = self.current_inspection
    if params[:after].empty?
      @remarks= @inspection.remarks
    else
      @remarks= @inspection.remarks.where("id > ?", params[:after].to_i) if params[:after].to_i > 0
    end
  end

  def destroy
		@remark = Remark.find(params[:id])
    @inspection = current_inspection
		if @remark.destroy
			flash.now[:info] = "Remark deleted"
		else
			flash.now[:error] = "Remark can not be deleted"
		end
	    # redirect_back_or root_url
	end

end
