class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    #can :manage, :all

    user ||= User.find(0)

    #user.permissions.find_each do |permission|
    #  if permission.remote_id
    #    can permission.permission.to_sym, permission.type.constantize
    #  else
    #    can permission.permission.to_sym, permission.type.constantize,
    #      :id => permission.remote_id
    #  end
    #end
    user.permissions.includes(:meta).find_each do |permission|
      meta = permission.meta
      type = permission.type.to_sym
      can type, meta
      if meta.collection
        can type, permission.meta.remote_type.constantize
      else
        can type,
          permission.meta.remote_type.constantize,
          meta_id: permission.meta_id
      end
    end
  end

  #def can?(action, subject, *args)
  #  if subject.respond_to?(:is_metable?) and subject.is_metable?
  #    old_subject = subject
  #    subject = subject.meta || subject
  #  end

  #  super action, subject, *args
  #end
end
