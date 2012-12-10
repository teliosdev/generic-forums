class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user ||= User.guest
    can do |action, subject_class, subject|
      can_result = false
      negated    = false
      remote_ids = [subject.id]
      action     = aliases(action)
      next false if subject.respond_to?(:ghost?) and subject.ghost?
      action_permissions = if subject.respond_to?(:ghost_permissions)
        subject.ghost_permissions(user, action)
      else
        action_permissions = user.permissions.where(
          :action => action,
          :remote_type => subject_class,
          :remote_id => remote_ids
        )
      end

      #if action_permissions.any?
        action_permissions.any? do |permission|
          negated = true if permission.negate
          can_result ||= true
        end
      #end

      can_result and not negated
    end
  end

  private

  def aliases(action)
    aliases = [action]
    aliases << :manage
    aliases
  end

end
