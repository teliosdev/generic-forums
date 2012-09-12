module PostsHelper

  def s(string)
    PostEvalHelper::Eval.new.score(string)[1].round(2)
  end

  def p(post)
  	puts "FORMATTER" + ("_" * 20)
  	puts YAML.dump post
    f = Formatter.new(post.body, post.format.to_sym)
    f.render.html_safe
  end
end
