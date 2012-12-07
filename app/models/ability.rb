class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.guest
    can do |action, subject_class, subject|
      can_result = false
      negated    = false
      remote_ids = [subject.id]
      remote_ids.push subject.ghost.id if subject.respond_to?(:ghost)
      action_permissions = user.permissions.where(
                                                  :action => aliases(action, user, subject),
                                                  :type => subject_class.to_s,
                                                  :remote_id => remote_ids
                                                )
      if action_permissions.any?
        can_result = action_permissions.any? do |permission|
          negated = true if permission.negate
          can_result ||= true
        end
      end

      can_result and not negated
    end
  end

  private

  def aliases(action, user, subject)
    aliases = [action]
    aliases << :manage
    case action
    when :edit_post
      aliases.push *check(:edit_post, :edit_own_post, user, subject)
    when :delete_post
      aliases.push *check(:delete_post, :delete_own_post, user, subject)
    end
    aliases
  end

  def check(basic_action, new_action, user, subject)
    if subject.respond_to?(:user) and subject.user == user
      return [basic_action, new_action]
    else
      return [basic_action]
    end
  end
end
