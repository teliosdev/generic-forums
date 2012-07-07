module PostsHelper
  def m(string, *args)
    RDiscount.new(string, *args).to_html.html_safe
  end

  def s(string)
    PostEvalHelper::Eval.new.score(string)[1].round(2)
  end
end
