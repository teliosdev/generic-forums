require "#{Rails.root}/lib/formatter/formatter"
require "#{Rails.root}/lib/app_config"

Formatter::Register.register :markdown, :render, RDiscount, *AppConfig.markdown_options
Formatter::Register.register :bbcode do |t|
  RbbCode::Parser.new.parse(t)
end
Formatter::Register.register :plain do |t|
  "<pre class='plain_text'><code>" + ERB::Util.html_escape(t) + "</code></pre>"
end

Formatter::Register.register :markdown, :quote do |t|
  "> " + (t.gsub(/\>(.*?)\n/, "").gsub(/\n/, "\n> ")) + "\n\n"
end

Formatter::Register.register :bbcode, :quote do |t|
  "[quote]" + t + "[/quote]"
end
