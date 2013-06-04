class CampaignsController < ApplicationController
  before_filter :signed_in_user
  load_and_authorize_resource
  def new
    @campaign = Campaign.new
    #may be add some filter that is only active teams/or not assigned to inspection or something like this

  end

  def create
    @campaign = Campaign.new(params[:campaign])
    insp_names = params[:insp_names].split(',')

    if @campaign.save
      insp_names.each do |n|
        i = @campaign.inspections.build(name: "#{@campaign.name} #{n}", comment: "Inspection for group #{n}", status: "active")
        if i.save
          # cool
        else
          #not-cool
        end

      end
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    #remove a roles connected to campaign when deleted
  end

  def archive
  end

  def show
    @campaign = Campaign.find(params[:id])
    @inspections = @campaign.inspections
  end

  def index
    @campaigns = Campaign.all
  end

  def edit
    @campaign = Campaign.find(params[:id])
  end

  def update
    @campaign = Campaign.find(params[:id])
    if @campaign.save
      flash[:success] = "campaign #{@campaign.name} modified"
      redirect_to @campaign
    else
      flash[:error] = "failed to modify the campaign"
      render 'edit'
    end
  end

end
