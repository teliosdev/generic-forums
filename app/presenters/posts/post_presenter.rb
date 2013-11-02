class Posts::PostPresenter < Curly::Presenter

  presents :post

  def post_body
    @post.formatted.html_safe
  end

  def user_info
    render 'posts/user_info', user: @post.user
  end

  def footer
    render 'posts/footer', post: @post
  end

  def post_anchor
    "post-#{@post.id}"
  end
end
