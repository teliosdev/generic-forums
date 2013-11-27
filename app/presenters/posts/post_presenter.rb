class Posts::PostPresenter < Curly::Presenter

  presents :post
  version 1
  depends_on 'posts/user_info'
  depends_on 'posts/footer'

  def post_body
    if @post.deleted
      deleted_tag('content')
    else
      @post.formatted.html_safe
    end
  end

  def user_info
    if @post.deleted
      deleted_tag
    else
      render 'posts/user_info', user: @post.user
    end
  end

  def post_class
    if @post.deleted
      "deleted"
    else
      ""
    end
  end

  def footer
    render 'posts/footer', post: @post
  end

  def cache_key
    [@post.id, current_user]
  end

  def cache_duration
    2.minutes
  end

  def post_anchor
    "post-#{@post.id}"
  end
end
