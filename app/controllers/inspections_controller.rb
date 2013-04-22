class InspectionsController < ApplicationController
	def new
		@inspection = Inspection.new
	end
	

	def create

		@inspection = Inspection.new
		@inspection.file = params[:inspection]
		if @inspection.save
			flash[:success] = "inpection created"
			redirect_to root_url
		else
			render 'new'
		end
	end 
end
