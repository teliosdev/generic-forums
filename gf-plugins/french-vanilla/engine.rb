puts "FRENCH VANILLA LOADED"
module FrenchVanilla
  class Engine < ::Rails::Engine

    #engine_name "french-vanilla"

    def self.root
      File.dirname(__FILE__)
    end

    require "#{root}/app/models/post"
    require "#{root}/lib/post_eval"
    require "#{root}/app_schema"

    config.to_prepare do
      Post.send :include, PostExtensions
    end

    paths["app/views"] = "#{root}/app/views"

    config.railties_order = [FrenchVanilla::Engine, :all, :main_app]

  end
end
