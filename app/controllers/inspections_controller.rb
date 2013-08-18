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
        @inspection.errors.full_messages.each {|m| flash.now[:alert] << m }
        @inspection.errors.clear
        redirect_to @inspection
      else
        flash.now[:error] = "Can not upload remarks. Try again"
        render 'upload_remarks'
      end
    else
      @inspection = Inspection.find(params[:id])
    end
  end

	def show
		@inspection = Inspection.find(params[:id])
    #@remarks = @inspection.remarks.page(params[:page]).per(5)

    self.current_inspection= @inspection
    flash.now[:error] ||= []
    @inspection.errors.full_messages.each {|m| flash.now[:error] << m }
    @inspection.errors.clear

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
      flash[:success] ||= []
      flash[:success] << "Inspection #{@inspection.name} has been created"
			redirect_to @inspection
    else
      errors = @inspection.errors.full_messages
      flash.now[:error] ||= []
      @inspection.errors.full_messages.each {|m| flash.now[:error] << m }
      @inspection.errors.clear
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
        flash[:error] ||= []
        flash[:error] << "Looks like you don't have rights to do that"
        @inspection.errors.clear
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
      roles = current_user.roles.map {|r| r.name if r.resource_id == @inspection.id }

      old_status = @inspection.status
      if current_user.has_role?(:moderator, Inspection) && (params[:status] != 'archived')
        @inspection.change_status params[:status]
      else
        @inspection.change_status params[:status]
      end

      if !@inspection.errors.any? && @inspection.save
        @inspection.close_deadline(old_status)
        flash.now[:success] ||= []
        #flash.now[:success] << "#{@inspection.fullname} status has been changed to #{@inspection.status.titleize}"
        respond_to do |format|
          format.js  {}
        end
        #render :edit
      else
        flash.now[:error] ||= []
        @inspection.errors.full_messages.each {|m| flash.now[:error] << m }
        @inspection.errors.clear
        #render :edit
      end
    end
  end

  def change_deadline
    @inspection = Inspection.find(params[:id])
    if !current_user.nil?
      #we don't think here about roles, they are controlled in abilities,
      # moderator can not use this action when status in 'archived' or 'closed'

      #if current_user.has_role?(:moderator, Inspection) && (params[:status] != 'archived')
      #  #there should be a checkup on validity of inspection )
        if @inspection.update_deadline(params[:status], Date.strptime(params[:dueDate], '%Y-%m-%d'))
          @inspection.reload
        else
          flash.now[:error] ||= []
          @inspection.errors.full_messages.each {|m| flash.now[:error] << m}
          @inspection.errors.clear
        end
        #respond_to do |format|
        #  format.js  {}
        #end
      #else
      #  if @inspection.update_deadline(params[:status], Date.strptime(params[:dueDate], '%Y-%m-%d'))
      #    @inspection.reload
      #    respond_to do |format|
      #      format.js  {}
      #    end
      #  else
      #    flash.now[:error] ||= []
      #    @inspection.errors.full_messages.each {|m| flash.now[:error] << m }
      #    @inspection.errors.clear
      #  end
      #end
    end
  end
  def add_user
    @inspection = Inspection.find(params[:id])

    @user = User.find(params[:user_id])
    flash.now[:error] ||= []
    flash.now[:error] << "Can not add user" unless @inspection.add_user(@user, params[:role])
    respond_to do |format|
      format.js  {}
    end
  end
  def remove_user
    @inspection = Inspection.find(params[:id])

    @user = User.find(params[:user_id])
    flash.now[:error] ||= []
    flash.now[:error] << "Can not remove user from #{@inspection.fullname}" unless @inspection.remove_user @user

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
