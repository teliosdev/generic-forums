class Posts::FooterPresenter < Curly::Presenter
  presents :post

  def post_time
    t('posts.post_time', date: time_ago_in_words(@post.created_at))
  end
end
