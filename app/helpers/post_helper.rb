module PostHelper

  def deleted_tag(type = 'other')
    content_tag :code, :class => "deleted" do
      I18n.t("post.deleted.#{type}")
    end
  end

  def rope_post_path(post)
    rope_path post.rope, anchor: "post-#{post.id}",
      page: page_for(post)
  end

  def page_for(post)
    post.id.fdiv(post.rope.class.default_per_page).ceil
  end

end
