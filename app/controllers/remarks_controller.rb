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
    @remark.user_id = current_user.id
		if @remark.save
			#flash.now[:success] = "Yahoo, we did it"
			# respond_with root_url
		else
			#flash.now[:error] = "Still troubling with remark creation"
			# redirect_to root_url
		end
	end

  def index
    #@inspection = self.current_inspection
    if params[:after].empty?
      @remarks= @inspection.remarks
    else
      @remarks= @inspection.remarks.where("id > ?", params[:after].to_i) if params[:after].to_i > 0
    end
  end

  def destroy
		@remark = Remark.find(params[:id])
    #@inspection = current_inspection
		if @remark.destroy
			flash.now[:info] = "Remark deleted"
		else
			flash.now[:error] = "Remark can not be deleted"
		end
	    # redirect_back_or root_url
	end

end
