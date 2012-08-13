class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.guest
    can do |action, subject_class, subject|
      can_result = false
      negated    = false
      action_permissions = user.permissions.where(:action => aliases_for_action(action), :type => subject_class.to_s)
      if action_permissions.any?
        can_result = action_permissions.any? do |permission|
          negated = true if permission.negate and
            (subject.nil? || permission.remote_id.nil? || permission.remote_id == subject.id)
          can_result ||= true &&
            (subject.nil? || permission.remote_id.nil? || permission.remote_id == subject.id)
        end
      end
      if subject.respond_to?(:ghost)
        can_result = subject.ghost.permissions.where({
          :action   => aliases_for_action(action),
          :type     => subject_class.to_s,
          :group_id => user.group_ids
        }).any? do |permission|
          negated = true if permission.negate
          can_result ||= true
        end
      end
      can_result and not negated
    end
    # Does not implement ghost threads; makes this utterly useless
    # because we'd have records that are exactly the same save for
    # the remote_id.
    #user.permissions.order("negate ASC").each do |permission|
    #  unless permission.remote_id
    #    if permission.negate
    #      cannot permission.action.to_sym, permission.type.constantize
    #    else
    #      can permission.action.to_sym, permission.type.constantize
    #    end
    #  else
    #    if permission.negate
    #      cannot permission.action.to_sym, permission.type.constantize, :id => permission.remote_id
    #    else
    #      can permission.action.to_sym, permission.type.constantize, :id => permission.remote_id
    #    end
    #  end
    #end
  end
end
