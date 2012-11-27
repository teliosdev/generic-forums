module UsersHelper
  def title_classes(user)
    v = user.groups.map { |g| "group_"+g.name.underscore.gsub(" ", "_") }
    if user.logged_in? and user.options[:show_online]
      v << "online"
    end
    v.join(" ")
  end
end
