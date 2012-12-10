require 'diff/lcs/hunk'
Ghost

Formatter::Register.register do
  markdown :render do |t|
    renderer = Redcarpet::Render::HTML.new :no_styles => true
    options  = {}
    AppConfig.markdown_options.each do |m|
      options[m] = true
    end
    md = Redcarpet::Markdown.new renderer, options
    md.render t
  end

  plain do |t|
    "<pre class='plain_text'><code>" + ERB::Util.html_escape(t) + "</code></pre>"
  end

  markdown :quote do |t|
    "> " + (t.gsub(/\>(.*?)\n/, "").gsub(/\n/, "\n> ")) + "\n\n"
  end
end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
end
