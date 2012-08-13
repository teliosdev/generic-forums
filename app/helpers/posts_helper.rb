module PostsHelper
  def m(string, *args)
    RDiscount.new(string, *args).to_html.html_safe
  end

  def s(string)
    PostEvalHelper::Eval.new.score(string)[1].round(2)
  end

  def b(string, *args)
    puts "BBCODE_PARSER" + ("_" * 20)
    puts "input : #{string}"
  	o = RBCode.new(string, *args).to_html.html_safe
    puts "output: #{o}"
    puts "DONE_________" + ("_"*20)
    o
  end

  def p(post)
  	if post.format == "markdown"
  		m(post.body, :smart, :filter_html, :safelink, :autolink)
  	elsif post.format == "bbcode"
  		b(post.body)
  	else
  		post.body
  	end
  end
end
