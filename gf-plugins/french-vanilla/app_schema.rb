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

DEFAULT_SCHEMA = PostEval::Schema.new
DEFAULT_SCHEMA.schema = GenericForums::Application.config.schema
DEFAULT_SCHEMA.compile_schema!
