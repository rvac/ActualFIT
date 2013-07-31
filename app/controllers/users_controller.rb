class UsersController < ApplicationController
	before_filter   :signed_in_user, only: [:edit, :update]
	before_filter   :correct_user, only: [:edit, :update]
  #load_and_authorize_resource

	def new
		@user = User.new
  end

  def destroy

  end
  def index
    if !current_user.nil?
      if ((current_user.has_role? :supervisor) || ( current_user.has_role? :admin ))
        @users = User.all
      elsif !current_inspection.nil?
        @users = current_inspection.users
      else
        @users = [] # think of something smart. What happen if there are several inspections or no inspections at all
      end
    end
  end
	def show
		@user = User.find(params[:id])
		@chat_messages = @user.chat_messages
    #@userTeams = []
    #if !@user.inspection_team_id.nil?
    #  @userTeams = [Participation.find(@user.inspection_team_id)]
    #end

	end
	def create
		@user = User.new(params[:user])

    @user.add_role params[:role].to_sym if Role.possible_roles.include?(params[:role])
		if @user.save
	    	sign_in @user
			flash[:success] = "Welcome aboard!"
			#redirect_to root_url
			redirect_to user_path(@user)

		else
			render 'new'
		end
	end

	def edit
   @user = User.find(params[:id])
   @campaigns = Campaign.all

	end

	# Function to be modified. Taken from SAMPLEAPP
	def update
    @user = User.find(params[:id])
    @campaigns = Campaign.all

    if params[:edit_roles]
      @campaigns.each do |c|
        c.inspections.each do |i|
          #trying to revoke all possible roles from user for all inspections
          Role.possible_roles.each do |r|
            @user.revoke r, i
            puts "role revoked"
          end


          # giving rights according to the result
          # later check if it is possible to send via form some shit, like admin
          if i.id == params[:inspectionID][c.id.to_s].to_i
            if Role.possible_roles.include? params[:role][c.id.to_s]
              @user.grant params[:role][c.id.to_s].to_sym, i
            end
          end
        end
      end
      redirect_to @user
    else
      if @user.update_attributes(params[:user])
        #handle a successful update
        flash[:success] = "Profile updated"
         sign_in @user
         redirect_to @user
      else
         render 'edit'
      end
    end

    #redirect_to @user
	end

	private

		def correct_user
		@user = User.find(params[:id])
    redirect_to (root_path) unless (current_user?(@user) || current_user.has_role?(:admin) || current_user.has_role?(:supervisor))

		end
end
