module PostsHelper

  def s(string)
    PostEvalHelper::Eval.new.score(string)[1].round(2)
  end

  def p(post)
    f = Formatter.new(post.body, post.format)
    f.render.html_safe
  end

  def q(post)
    f = Formatter.new(post.body, post.format)
    f.quote
  end
end
