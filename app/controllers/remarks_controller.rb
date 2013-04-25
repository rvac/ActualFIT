class RemarksController < ApplicationController
	before_filter :signed_in_user
	respond_to :html, :js
	
	def create
		@remark = current_user.remarks.build(params[:remark])

		if @remark.save
			# flash[:success] = "Yahoo, we did it"
			# respond_with root_url
		else
			flash.now[:error] = "Still troubling with remark creation"
			# redirect_to root_url
		end
	end

	def destroy
		@remark = Remark.find(params[:id])
		if @remark.destroy
			flash.now[:info] = "Remark deleted"
		else
			flash.now[:error] = "Remark can not be deleted"
		end
	    # redirect_back_or root_url
	end

end
