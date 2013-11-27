class Posts::UserInfoPresenter < Curly::Presenter
  presents :user

  version 1

  def online
    if @user.online?
      'online'
    else
      'offline'
    end
  end

  def avatar(size)
    image_tag(@user.gravatar_url size: size)
  end

  def name
    link_to @user.name, '/'
  end

  def title
    @user.name
  end

  def misc
    render 'posts/user_misc', user: @user
  end
end
