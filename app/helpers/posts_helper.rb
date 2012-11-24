module PostsHelper

  def format(post)
    f = Formatter.new(post.body, post.format)
    f.render.html_safe
  end

  def q(post)
    f = Formatter.new(post.body, post.format)
    f.quote
  end

  def determine_path(post)
    #puts "DETERMINE_PATH_____________________________"
    #p post
    board_rope_posts_path(post.board.id, post.rope.id,
      :page => post.page(@user.per_page(:posts)),
      :anchor => "post-#{post.id}"
    )
  end
end
