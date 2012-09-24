GenericForums::Application.config.schema = {
  :schema => {
    :letters => { :ratios => { :lower_to_clean => 10, :upper_to_clean => 5 } },
    :words   => { :ratios => { :number_to_possible => 10 } },
    :sentences => { :ratios => { :proper_to_count => 10 } }
  }, :clean => [
    [ /\[(.+?)\](.*?)\[\/\1\]/, "" ],
    [ /\n=+/, "" ]
  ]
}

require "#{Rails.root}/lib/formatter/formatter"

Formatter::Register.register :markdown, RDiscount
Formatter::Register.register :bbcode do |t|
  RbbCode::Parser.new.parse(t)
end
Formatter::Register.register :plain do |t|
  "<pre class='plain_text'><code>" + ERB::Util.html_escape(t) + "</code></pre>"
end

require "#{Rails.root}/lib/app_config"
