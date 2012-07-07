module UsersHelper
  def title_classes(user)
    v = user.groups.map { |g| "group_"+g.name.underscore.gsub(" ", "_") }
    v.join(" ")
  end
end
