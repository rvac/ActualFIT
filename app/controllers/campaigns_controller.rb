class CampaignsController < ApplicationController
  before_filter :signed_in_user
  load_and_authorize_resource
  def new
    @campaign = Campaign.new
    #may be add some filter that is only active teams/or not assigned to inspection or something like this
    @teams = InspectionTeam.all
  end

  def create
    @campaign = Campaign.new(params[:campaign])
    teamsID = params[:teamID].keys #this is to be changed accordingly, search for teams. add only real ones
    # insert here some exception handler in case of teams not found. (fake ID are sent via form)
    @teams = InspectionTeam.find(teamsID)


    #@current_inspection = @inspection
    # @inspection.file = params[:inspection]
    if @campaign.save

      fi = 0 # failded inspections counter
      @teams.each do |i|
         insp = Inspection.new(name: "Inspection, #{@campaign.name}", status: 'active')
         insp.campaign_id = @campaign.id
         insp.inspection_team_id = i.id
         fi += 1 unless !insp.save
      end

      if fi == 0
        flash[:success] = "Campaign #{@campaign.name} successfully created"
      else
        flash[:error] = "Campaign #{@campaign.name} created with errors"
      end

      redirect_to root_url
    else
      @teams = InspectionTeam.all
      render 'new'
    end
  end
  def destroy
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
