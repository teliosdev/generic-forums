class Ropes::RopePresenter < Curly::Presenter
  presents :rope

  def title
    @rope.title
  end

  def user_name
    @rope.user.name
  end

  def posted
    link_to t('boards.posted', user: @rope.user.name,
      date: l(@rope.created_at, format: :mini)), '/user'
  end

  def pages
    pluralize(@rope.posts.size.fdiv(Setting.threads.per_page).ceil, 'page')
  end

  def views
    pluralize(@rope.impressions_count, 'view')
  end

  def replies
    pluralize(@rope.posts.size - 1, 'reply')
  end

  def latest_post
    if @rope.posts.size == 0
      t('boards.latest.none')
    else
      render 'ropes/latest_post', rope: @rope,
        last_post: @rope.last_post
    end
  end

  def link
    rope_url @rope
  end

end
