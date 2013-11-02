class Shared::HeaderPresenter < Curly::Presenter
  def forum(info)
    Setting.forum[info]
  end

  def user_info
    if user_signed_in?
      render "shared/header/info"
    else
      form_for(User.new, url: user_session_path) do |f|
        render "shared/header/login", form: f
      end
    end
  end

  def main_link
    root_path
  end
end
