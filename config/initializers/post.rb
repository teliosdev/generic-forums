GenericForums::Application.config.schema = {
  :schema => {
    :letters => { :ratios => { :lower_to_clean => 10, :upper_to_clean => 5 } },
    :words   => { :ratios => { :number_to_possible => 10 } },
    :sentences => { :ratios => { :proper_to_count => 10 } }
  }, :clean => [
    [ /\[(.+?)\](.*?)\[\/\1\]/, "" ]
  ]
}

require "#{Rails.root}/lib/app_config"
