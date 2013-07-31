  class Ability
  include CanCan::Ability

  def initialize(user)
    #I am not sure about edit, should I remove it and refactor controllers or it is ok
    alias_action :create, :read, :edit, :update, :destroy, to: :crud
    user ||= User.new   #for guest users
    can :read, :all
    #can :crud, :all

    #everyone who enrolled into inspection can dowload artifacts by batch
    can :download_artifacts, Inspection, id: Inspection.with_role(:any, user).map(&:id)
    if user.has_role? :admin
      can :manage, :all
    end

    if user.has_role? :supervisor
      can :crud, :all
    end
      # only on inspection where he is allowed
    can :create, Artifact, inspection_id: Inspection.with_role(:author, user).map(&:id)
    can :crud, Artifact, user_id: user.id
    can :destroy, Artifact, inspection_id: Inspection.with_role(:moderator, user).map(&:id)


    # only on inspection where he is allowed
    #can :destroy, Artifact

    # Add management, that inspector or whoever can create only on inspection that he can
    can :create, Remark, inspection_id: Inspection.with_role(:inspector, user).map(&:id)
    can :destroy, Remark, user_id: user.id  #author can delete his comment
    can :crud, Remark, inspection_id: Inspection.with_role(:moderator, user).map(&:id)
    can :create, ChatMessage, inspection_id: Inspection.with_role(:inspector, user).map(&:id)
    can :create, ChatMessage, inspection_id: Inspection.with_role(:author, user).map(&:id)
    can :create, ChatMessage, inspection_id: Inspection.with_role(:moderator, user).map(&:id)


    can :upload_remarks, Inspection, id: Inspection.with_role(:moderator, user).map(&:id)
    can :upload_remarks, Inspection, id: Inspection.with_role(:inspector, user).map(&:id)


    #Managing deadlines
    can :crud, Deadline, inspection_id: Inspection.with_role(:moderator, user).map(&:id)
  end

end