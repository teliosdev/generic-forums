#save it as config/initializers/html_in_json.rb
ActiveSupport.escape_html_entities_in_json = true

#next line is not really compulsory. It just sanitizes output(not just replaces with \u values of html entities) to protect you from DOM XSSes.
ActiveSupport::JSON::Encoding::ESCAPED_CHARS.merge! '<' => '&lt;'
