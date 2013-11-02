class Shared::FooterPresenter < Curly::Presenter

  def forum(info)
    Setting.forum[info]
  end

  def link(type)
    case type
    when "top"
      link_to "Back to top", "#top"
    when "about"
      link_to "About", "#about"
    else
      ""
    end
  end
end
