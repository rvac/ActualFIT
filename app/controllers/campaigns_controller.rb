class CampaignsController < ApplicationController
  before_filter :signed_in_user
  load_and_authorize_resource

  def new
    @campaign = Campaign.new
    #may be add some filter that is only active teams/or not assigned to inspection or something like this
  end

  def download_template
    send_file Rails.public_path + "/templates/group_assignment_template.xls"
  end
  def create
    #@campaign = Campaign.new(params[:campaign])
    #insp_names = params[:insp_names].split(',')

    if @campaign.save
      flash[:notice] = @campaign.errors.full_messages.join(' ') if @campaign.errors.any?
      @campaign.errors.clear
      redirect_to @campaign
    else
      flash[:error] = @campaign.errors.full_messages.join(' ')
      @campaign.errors.clear
      render 'new'
    end
  end

  def destroy
    #remove a roles connected to campaign when deleted
    @campaign = Campaign.find(params[:id])
    if !current_user.nil?
      if ((current_user.has_role? :supervisor) || ( current_user.has_role? :admin ))
        @campaign.destroy
        redirect_to action: :index
      else
        flash[:error] = "Looks like you don't have right to do that"
        redirect_to root_url
      end
    end
  end

  def archive
  end

  def show
    @campaign = Campaign.find(params[:id])
    @inspections = @campaign.inspections
  end

  def index
    @campaigns = Campaign.all
    store_location
  end

  def edit
    @campaign = Campaign.find(params[:id])
  end

  def update
    @campaign = Campaign.find(params[:id])
    @campaign.update_attributes(params[:campaign])
    if @campaign.save
      flash[:success] = "campaign #{@campaign.name} modified"
      redirect_to @campaign
    else
      flash[:error] = "failed to modify the campaign"
      render 'edit'
    end
  end

end
