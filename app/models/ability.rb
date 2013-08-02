  class Ability
  include CanCan::Ability

  def initialize(user)
    #I am not sure about edit, should I remove it and refactor controllers or it is ok
    alias_action :create, :read, :edit, :update, :destroy, to: :crud
    user ||= User.new   #for guest users
    can :read, :all
    #can :crud, :all

    if user.has_role? :admin
      can :manage, :all
    end

    if user.has_role? :supervisor
      can :crud, :all
      can :add_user, Inspection
      can :remove_user, Inspection
      can :download_artifacts, Inspection
    end

    #everyone who enrolled into inspection can dowload artifacts by batch
    can :download_artifacts, Inspection, id: Inspection.with_role(:scribe, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq



    # only on inspection where he is allowed
    #check the added stuff after user.id!!


    #moderator can chage status when it is active, i.e. when status is not 'closed' or 'archived'

    # only on inspection where he is allowed
    #can :destroy, Artifact
    # Add management, that inspector or whoever can create only on inspection that he can

    #FOR EVERY USER
    can :destroy, Remark, user_id: user.id, inspection_id: user.inspections.select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq  #author can delete his comment

    #INSPECTOR ABILITIES
    can :create, ChatMessage, inspection_id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :create, Remark, inspection_id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :upload_remarks, Inspection, id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :download_artifacts, Inspection, id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    #this stuff is for writing abilities only with selected inspection statuses (for ordinary users of course
    # special action in controller - change status, moderator can do this only for active! isnpection
    #Inspection.with_role(:inspector).select {|i| !(['closed', 'archived'].include?(i.status))}.map(&:id).uniq

    #AUTHOR ABILITIES
    can :create, Artifact, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :crud, Artifact, user_id: user.id, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :create, ChatMessage, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :download_artifacts, Inspection, id: Inspection.with_role(:author, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq

    #MODERATOR ABILITIES
    can :destroy, Artifact, inspection_id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :create, ChatMessage, inspection_id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :crud, Remark, inspection_id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :change_status, Inspection, id: Inspection.with_role(:moderator, user).select {|i| i.active? }.map(&:id).uniq
    can :upload_remarks, Inspection, id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :download_artifacts, Inspection, id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    #Managing deadlines
    #can :crud, Deadline, inspection_id: Inspection.with_role(:moderator, user).map(&:id)
  end

end