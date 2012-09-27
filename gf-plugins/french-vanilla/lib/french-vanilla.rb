puts "FRENCH VANILLA LOADED"

require 'delayed_job_active_record'
require 'reputation_system'

module FrenchVanilla
  class Engine < ::Rails::Engine

    engine_name "french_vanilla" # it can't be french-vanilla because
                                 # activerecord doesn't like - in
                                 # migration file names

    def self.root
      File.dirname File.dirname(__FILE__)
    end

    require "#{root}/app/models/post"
    require "#{root}/app/models/user"
    require "#{root}/lib/french-vanilla/post_eval"
    require "#{root}/lib/app_schema"

    config.to_prepare do
      Post.send :include, PostExtensions
      User.send :include, UserExtensions
      #GenericForums::Application.assets.append_path "#{root}/vendor/assets/javascripts"
      ApplicationController.send(:prepend_view_path, "#{FrenchVanilla::Engine.root}/app/views")
    end

    paths["app/views"] = "#{root}/app/views"
    paths["app/assets"] = "#{root}/vendor/assets"


    config.railties_order = [FrenchVanilla::Engine, :all, :main_app]

  end
end
