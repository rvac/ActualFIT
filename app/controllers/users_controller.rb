class UsersController < ApplicationController
	before_filter   :signed_in_user, only: [:edit, :update]
	before_filter   :correct_user, only: [:edit, :update]
  #load_and_authorize_resource

	def new
		@user = User.new
	end
	def show
		@user = User.find(params[:id])
		@chat_messages = @user.chat_messages
    @userTeams = []
    if !@user.inspection_team_id.nil?
      @userTeams = [InspectionTeam.find(@user.inspection_team_id)]
    end

	end
	def create
		@user = User.new(params[:user])

    @user.add_role params[:role].to_sym if ["author", "inspector", "moderator", "scribe", "admin", "supervisor"].include?(params[:role])
		if @user.save
	    	sign_in @user
			flash[:success] = "Welcome aboard!"
			redirect_to root_url
			# redirect_to current_user(@user)

		else

			render 'new'
		end
	end

	def edit
   @user = User.find(params[:id])
   @campaigns = Campaign.all
   @teamNames = []
   @teams = []
   j = 0
   @inspections = []
   @userTeams = []
   @campaigns.each do |c|
     @teamNames[j] = []
     @teams[j] = []

     @inspections[j] = c.inspections
     @inspections[j].each do |i|
       t = InspectionTeam.find(i.inspection_team_id)
       @teams[j] << t
       @teamNames[j] << t.name
     end
     j+=1
   end

   if !@user.inspection_team_id.nil?
     @userTeams = [InspectionTeam.find(@user.inspection_team_id)]
   end

	end

	# Function to be modified. Taken from SAMPLEAPP
	def update
	  @user = User.find(params[:id])
    @campaigns = Campaign.all
    @teamNames = []
    @teams = []
    j = 0
    @inspections = []
    @userTeams = []
    @campaigns.each do |c|
      @teamNames[j] = []
      @teams[j] = []

      @inspections[j] = c.inspections
      @inspections[j].each do |i|
        t = InspectionTeam.find(i.inspection_team_id)
        #trying to revoke all possible roles from user for all inspections
        Role.possible_roles.each do |r|
          @user.revoke r, i
        end
        @teams[j] << t
        @teamNames[j] << t.name
      end
      j+=1
    end

    # giving rights according to the result
    # later check if it is possible to send via form some shit, like admin

    j = 0
    params[:teamID].each do |k, tID|
      @inspections[j].each do |i|
        # if an inspection belong to selected team - then grant permission

        # number of roles equal to number of teams, so it is ok to have the same key

        @user.grant params[:role][k].to_sym, i if i.inspection_team_id == tID.to_i
        @user.inspection_team_id = tID.to_i if i.inspection_team_id == tID.to_i
      end
      j += 1
    end

	  if @user.update_attributes(params[:user])
	     #handle a successful update
	     flash[:success] = "Profile updated"
	     sign_in @user
	     redirect_to @user
	  else
	     render 'edit'
	  end


    #redirect_to @user
	end

	private

		def correct_user
		@user = User.find(params[:id])
		redirect_to (root_path) unless current_user?(@user)

		end

		def admin?
			!/(admin)/.match(@user.role).nil?
		end
		def moderator?
			!/(moderator)/.match(@user.role).nil?
		end
		def author?
			!/(author)/.match(@user.role).nil?
		end
end
