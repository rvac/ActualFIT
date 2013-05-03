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
      can :create, Artifact
      can :edit, Artifact, :user_id => user.id
      can :destroy, Artifact, :user_id => user.id
    end

    if user.has_role? :moderator
      can :crud, Remark
    end

    if user.has_role? :inspector
      # Add management, that inspector or whoever can create only on inspection that he can
      can :crud, Remark
      can :create, Remark

    end
  end

end