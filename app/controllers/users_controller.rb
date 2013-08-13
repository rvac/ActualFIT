class UsersController < ApplicationController
	before_filter   :signed_in_user, only: [:new, :create]
  #fix this stuff!!   if not work
	before_filter   :correct_user, only: [:edit, :update]
  #load_and_authorize_resource

	def new
		@user = User.new
  end

  def destroy
     @user = User.find(params[:id])
     if !current_user.nil?
       if ((current_user.has_role? :supervisor) || ( current_user.has_role? :admin ))
         @user.destroy
         flash[:success] = "User was deleted"
         redirect_to action: :index
       else
         flash.now[:error] = "Looks like you don't have right to do that"
       end
     end
  end
  def index
    if !current_user.nil?
      if ((current_user.has_role? :supervisor) || ( current_user.has_role? :admin ))
        @users = User.all
      elsif !current_inspection.nil?
        #@users = current_inspection.users
        @users = current_inspection.users.uniq

      else
        @users = [] # think of something smart. What happen if there are several inspections or no inspections at all
      end
      store_location
    end
  end
	def show
		@user = User.find(params[:id])
		if @user.attributes.values.compact.count <= 10
      flash.now[:notice] = "Please add some information to your profile"  if current_user?(@user)
    end

	end
	def create
		@user = User.new(params[:user])
		if @user.save
	    	sign_in @user if current_user.nil?
			flash[:success] = "Welcome aboard!"
			#redirect_to root_url
      flash[:notice] = "Please add some information to your profile"
			redirect_to edit_user_path(@user)
		else
			render 'new'
		end
	end

	def edit
   @user = User.find(params[:id])
   @campaigns = Campaign.all

	end

  # function to delete permissions from user profile
  # to use dynamic dropdown. If campaign is chosen - than by JS list of inspections is modified
  # after granting role - add user to inspection
  def revoke_role
    @user = User.find(params[:id])
    if !@user.nil?
      role = params[:role]
      if !params[:resource_id].nil? && !params[:resource_type].nil? && Role.possible_roles.include?(role)
        object = params[:resource_type].constantize.find(params[:resource_id])
        if !object.nil?
          @user.revoke role, object
        end
      elsif Role.possible_roles.include?(role)
        @user.revoke role
      end
      respond_to do |format|
        format.js  {}
      end
    end
  end
  # function to delete permissions from user profile
  def grant_role
    @user = User.find(params[:id])
    if !@user.nil?
      role = params[:role]

      params[:resource_id] = nil if params[:resource_id] == ""
      if !params[:resource_id].nil?  && Role.possible_roles.include?(role)
        object = Inspection.find(params[:resource_id])
        if !object.nil?
          @user.grant role, object
          #the following is not optimal for universal role granting. But we don't care. The way of doing stuff is optional
          Participation.create user: @user, inspection: object, role: role if !(@user.inspections.map(&:id).include?(object.id))
          #object.users << @user if !(@user.inspections.map(&id).include?(object.id))
        end
      elsif Role.possible_roles.include?(role)
        @user.grant role
      end
      respond_to do |format|
        format.js  {}
      end
    end
  end
	# Function to be modified. Taken from SAMPLEAPP
	def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      #handle a successful update
      flash[:success] = "Profile updated"
      sign_in @user if current_user?(@user)
      #redirect_to @user
      redirect_back_or @user
    else
       render 'edit'
    end
    #redirect_to @user
	end
  def get_profile_picture
    @user = User.find(params[:id])
    if !@user.profile_picture.nil? && !@user.content_type.nil?
      send_data @user.profile_picture, type: @user.content_type, :disposition => 'inline'
    else
      #zalupa
    end
  end
	private

		def correct_user
		@user = User.find(params[:id])
    redirect_to (edit_user_path(@user)) unless (current_user?(@user) || current_user.has_role?(:admin) || current_user.has_role?(:supervisor))

		end
end
