class Ropes::LatestPostPresenter < Curly::Presenter

  presents :rope, :last_post

  def t(key)
    case key
    when 'latest_post'
      I18n.t('boards.latest.other')
    when 'post_link'
      I18n.t('boards.latest.go').html_safe
    else
      ''
    end
  end

  def user_link
    '/user'
  end

  def user_name
    @last_post.user.name
  end

  def post_link
    rope_path(@rope,
      page: @rope.posts.size.fdiv(Setting.threads.per_page).ceil,
      anchor: "post-#{@last_post.id}"
    )
  end
end
