class ParticipationsController < ApplicationController
  before_filter :signed_in_user
  load_and_authorize_resource

  def new
    @team = Participation.new
    @users = User.all
    @inspections = Inspection.all
  end
  def create
    @team = Participation.new(params[:inspection_team])

    if @inspection_team.save
      flash[:success] = 'inspection team created'
      redirect_to root_url
    else
      flash[:error] = 'have problems with creating inspection team'
      render 'new'
    end

  end

  def destroy
  end
  def index
    @teams = Participation.all
  end

  def show
    @team = Participation.find(params[:id])
  end
  def edit
    @inspection_team = Participation.find(params[:id])
  end

  def update
    @inspection_team = Participation.find(params[:id])

    # do some update action here
  end
end
