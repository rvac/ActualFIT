class Ability
  include CanCan::Ability

  def initialize(user)
    #I am not sure about edit, should I remove it and refactor controllers or it is ok
    alias_action :create, :read, :edit, :update, :destroy, to: :crud
    user ||= User.new   #for guest users


    can :read, :all
    can :create, ChatMessage

    if user.has_role? :admin
      can :manage, :all
    end

    if user.has_role? :supervisor
      can :crud, :all
    end

    if user.has_role? :author
      # only on inspection where he is allowed
      can :create, Artifact
      can :crud, Artifact, :user_id => user.id
    end

    if user.has_role? :moderator
      # only on inspection where he is allowed
      can :crud, Remark
      can :destroy, Artifact
    end

    if user.has_role? :inspector
      # Add management, that inspector or whoever can create only on inspection that he can
      can :create, Remark
      can :destroy, Remark, user_id: user.id
    end
  end

end