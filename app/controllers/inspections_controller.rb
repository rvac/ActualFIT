class InspectionsController < ApplicationController
	before_filter :signed_in_user
  load_and_authorize_resource
  respond_to :html, :js

	def new
		@inspection = Inspection.new
    #authorize! :create, @inspection
	end

  def download_artifacts
    @inspection = Inspection.find(params[:id])
    #@inspection.artifacts.each do |a|
    #  send_data a.file, filename: a.filename,
    #            type: a.content_type
    #end
    redirect_to @inspection
  end
  def download_remarks
    @inspection = Inspection.find(params[:id])
    remarks = @inspection.remarks
  end
  def download_remarks_template
    send_file Rails.public_path + "/templates/remarks_template.xlsx"
  end
  def upload_remarks
    if request.post?
      @inspection = Inspection.find(params[:id])

      if Remark.parse_excel( params[:remarks_file], @inspection, current_user )
        flash[:alert] ||= []
        flash[:alert] << @inspection.errors.full_messages.join()
        @inspection.errors.clear
        redirect_to @inspection
      else
        flash.now[:error] = "Can not upload remarks. Try again"
        render 'upload_remarks'
      end
    else
      #handle get. I.e. do nothing for now
    end
  end

	def show
		@inspection = Inspection.find(params[:id])
    #@remarks = @inspection.remarks.page(params[:page]).per(5)

    self.current_inspection= @inspection
    flash.now[:notice] = "Ask author to add some artifacts" if @inspection.artifacts.empty?
    store_location
	end

	def create
    #@inspection = Inspection.build(params[:inspection])
    @inspection.active!
    if params[:campaign_id] == "" || params[:campaign_id].nil?
      params[:campaign_id] = nil
    elsif Campaign.find(params[:campaign_id])
      @inspection.campaign_id = params[:campaign_id]
    end
      if @inspection.save
			flash[:success] = "inspection #{@inspection.name} created"
			redirect_to @inspection
    else
      errors = @inspection.errors.full_messages
      flash[:error] = errors.join(" ")
			render 'new'
		end
  end


  def index
    @inspections = Inspection.all


  #  respond_to do |format|
  #    format.js
  #  end
  end

  def destroy
    #remove a roles connected to inspections when deleted
    @inspection = Inspection.find(params[:id])
    if !current_user.nil?
      if ((current_user.has_role? :supervisor) || ( current_user.has_role? :admin ))
        @inspection.destroy
        redirect_back_or action: :index
      else
        flash.now[:error] = "Looks like you don't have right to do that"
      end
    end
  end


  def edit
    @inspection = Inspection.find(params[:id])

  end
  def change_status
    @inspection = Inspection.find(params[:id])
    if !current_user.nil?
      #we don't think here about roles, they are controlled in abilities,
      # moderator can not use this action when status in 'archived' or 'closed'
      old_status = @inspection.status
      if current_user.has_role?(:moderator, Inspection) && (params[:status] != 'archived')
        @inspection.status = params[:status]
      else
        @inspection.status = params[:status]
      end

      if @inspection.save
        @inspection.close_deadline(old_status)
        flash.now[:success] = "Inspection status is now #{@inspection.status}"
        respond_to do |format|
          format.js  {}
        end
        #render :edit
      else
        flash.now[:error] = "Can not change inspection status, sorry!"
        #render :edit
      end
    end
  end

  def change_deadline
    @inspection = Inspection.find(params[:id])
    if !current_user.nil?
      #we don't think here about roles, they are controlled in abilities,
      # moderator can not use this action when status in 'archived' or 'closed'

      if current_user.has_role?(:moderator, Inspection) && (params[:status] != 'archived') && (params[:status] != 'closed')
        #there should be a checkup on validity of inspection )
        if @inspection.update_deadline(params[:status], Date.strptime(params[:dueDate], '%Y-%m-%d'))
          respond_to do |format|
            format.js  {}
          end
        else
          flash.now[:error] = "Deadline for the inspection is not valid"
        end
      else
        if @inspection.update_deadline(params[:status], Date.strptime(params[:dueDate], '%Y-%m-%d'))
          @inspection.reload
          respond_to do |format|
            format.js  {}
          end
        else
          flash[:error] = "Deadline for the inspection is not valid"
        end
      end
    end
  end
  def add_user
    @inspection = Inspection.find(params[:id])

    @user = User.find(params[:user_id])
    flash.now[:error] = "can not add user" unless @inspection.add_user(@user, params[:role])
    respond_to do |format|
      format.js  {}
    end
  end
  def remove_user
    @inspection = Inspection.find(params[:id])

    @user = User.find(params[:user_id])
    flash[:error] = "Can not remove user from #{@inspection.fullname}" unless @inspection.remove_user @user

    respond_to do |format|
      format.js  {}
    end
      #@inspection.participations.select{|p| p.user_id == user.id}.each{|p| p.destroy}

  end
  def update
    @inspection = Inspection.find(params[:id])
    @inspection.update_attributes(params[:inspection])
  end
end
