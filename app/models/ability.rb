  class Ability
  include CanCan::Ability

  def initialize(user)
    #I am not sure about edit, should I remove it and refactor controllers or it is ok
    alias_action :create, :read, :edit, :update, :destroy, to: :crud
    user ||= User.new   #for guest users
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



    #INSPECTOR ABILITIES
    can :read, Artifact, inspection_id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :read, Inspection, id: Inspection.with_role(:inspector, user).select {|i| !i.archived?}.map(&:id).uniq
    can :read, ChatMessage, inspection_id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :read, Remark, inspection_id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq

    can :create, ChatMessage, inspection_id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :create, Remark, inspection_id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq

    can :destroy, Remark, user_id: user.id, inspection_id: user.inspections.select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq  #author can delete his comment

    can :upload_remarks, Inspection, id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :download_artifacts, Inspection, id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :download_remarks_template, Inspection, id: Inspection.with_role(:inspector, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq



    #AUTHOR ABILITIES
    #can :create, Artifact, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'closed', 'archived'].include?(i.status))}.map(&:id).uniq
    can :read, Artifact, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :read, Inspection, id: Inspection.with_role(:author, user).select {|i| !i.archived?}.map(&:id).uniq
    can :read, ChatMessage, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :read, Remark, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq

    can :crud, Artifact, user_id: user.id, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :create, Artifact, inspection_id: Inspection.with_role(:author, user).select {|i| (['upload','rework'].include?(i.status))}.map(&:id).uniq
    can :create, ChatMessage, inspection_id: Inspection.with_role(:author, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :download_artifacts, Inspection, id: Inspection.with_role(:author, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq



    #MODERATOR ABILITIES
    can :read, Inspection, id: Inspection.with_role(:moderator, user).select {|i| !i.archived?}.map(&:id).uniq
    can :read, Artifact, inspection_id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :read, ChatMessage, inspection_id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq

    # can create upload a guide lines n "setup" phase
    can :create, Artifact, inspection_id: Inspection.with_role(:moderator, user).select {|i| i.status == "setup" }.map(&:id).uniq
    can :create, ChatMessage, inspection_id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq

    can :edit, Artifact, user_id: user.id, inspection_id: user.inspections.select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq  #author can delete his comment

    can :destroy, Artifact, inspection_id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq

    can :manage, Remark, inspection_id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq

    can :change_status, Inspection, id: Inspection.with_role(:moderator, user).select {|i| i.active? }.map(&:id).uniq
    can :change_deadline, Inspection, id: Inspection.with_role(:moderator, user).select {|i| i.active? }.map(&:id).uniq
    can :upload_remarks, Inspection, id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :download_artifacts, Inspection, id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    can :download_remarks_template, Inspection, id: Inspection.with_role(:moderator, user).select {|i| !(['finished', 'archived'].include?(i.status))}.map(&:id).uniq
    #Managing deadlines
    #can :crud, Deadline, inspection_id: Inspection.with_role(:moderator, user).map(&:id)
  end

end