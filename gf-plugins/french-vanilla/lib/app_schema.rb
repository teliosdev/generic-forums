module FrenchVanilla
  class Engine

    initializer "french-vanilla.post-eval" do
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

      ::PostEval::Eval::DEFAULT_SCHEMA = PostEval::Schema.new
      ::PostEval::Eval::DEFAULT_SCHEMA.schema = GenericForums::Application.config.schema
      ::PostEval::Eval::DEFAULT_SCHEMA.compile_schema!
    end
  end
end
