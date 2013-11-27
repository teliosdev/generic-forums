require 'generic_data_formatter/render'

r = GenericDataFormatter::Render::HTML.new(no_styles: true,
  hard_wrap: true, escape_html: true)
m = Redcarpet::Markdown.new(r, fenced_code_blocks: true,
  tables: true, autolink: true)

GenericDataFormatter.add_formatter :markdown do |body, options|
  #RDiscount.new(body, :smart, :filter_html, *options.keys).to_html
  m.render(body).html_safe
end

GenericDataFormatter.add_formatter :plain do |body, options|
  "<pre class='plain'><code>#{ERB::Util.html_escape(body)}</code></pre>".html_safe
end
