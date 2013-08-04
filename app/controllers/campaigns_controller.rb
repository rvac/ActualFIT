class CampaignsController < ApplicationController
  before_filter :signed_in_user
  load_and_authorize_resource

  def new
    @campaign = Campaign.new
    #may be add some filter that is only active teams/or not assigned to inspection or something like this

  end


  def create
    #@campaign = Campaign.new(params[:campaign])
    #insp_names = params[:insp_names].split(',')

    if @campaign.save
      #if params[:assignments]
      # @campaign.import params[:assignments]
      #end
      #insp_names.each do |n|
      #  i = @campaign.inspections.build(name: "#{@campaign.name} #{n}", comment: "Inspection for group #{n}", status: "active")
      #  if i.save
      #    # cool
      #  else
      #    #not-cool
      #  end
      #
      #end
      redirect_to @campaign
    else
      render 'new'
    end
  end

  def destroy
    #remove a roles connected to campaign when deleted
    @campaign = Campaign.find(params[:id])
    if !current_user.nil?
      if ((current_user.has_role? :supervisor) || ( current_user.has_role? :admin ))
        @campaign.destroy
        redirect_back_or :index
      else
        flash.now[:success] = "Looks like you don't have right to do that"
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
