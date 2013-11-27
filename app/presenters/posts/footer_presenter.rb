class Posts::FooterPresenter < Curly::Presenter
  presents :post

  version 1

  def post_time
    if @post.deleted
      deleted_tag
    else
      t('posts.post_time', date: time_ago_in_words(@post.created_at))
    end
  end

  def post_replies
    if @post.replies.size > 0 && !@post.deleted
      I18n.t('posts.replies_html', links: @post.replies.map do |reply|
        link_to(reply.id, rope_post_path(reply))
      end.join(", ")).html_safe
    else
      ""
    end
  end

  def post_parent
    if @post.parent && !@post.deleted
      I18n.t('posts.parent_html',
        link: link_to(@post.parent.id,
          rope_post_path(@post.parent))).html_safe
    else
      ""
    end
  end

  def post_number
    "Post #{@post.id}."
  end

  def post_options
    if @post.deleted
      render "posts/deleted_post_options", post: @post
    else
      render "posts/post_options", post: @post
    end
  end

end
