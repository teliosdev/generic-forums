class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.find(0)
    #can do |action, subject_class, subject|
    #  user.permissions.find_all_by_action(aliases_for_action(action)).any? do |permission|
    #    permission.type == subject_class.to_s &&
    #      (subject.nil? || permission.remote_id.nil? || permission.remote_id == subject_id)
    #  end
    #end
    user.permissions.each do |permission|
      unless permission.remote_id
        can permission.action.to_sym, permission.type.constantize
      else
        can permission.action.to_sym, permission.type.constantize, :id => permission.remote_id
      end
    end
  end
end
