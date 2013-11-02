# encoding: utf-8

$LOAD_PATH.unshift "lib"
require "generic_data_formatter/version"

Gem::Specification.new do |gem|
  gem.name              = "generic_data_formatter"
  gem.version           = GenericDataFormatter::VERSION
  gem.date              = Time.now.strftime('%Y-%m-%d')
  gem.summary           = "Handles formatting data."
  gem.homepage          = "http://github.com/redjazz96/generic_data_formatter"
  gem.email             = ["redjazz96@gmail.com"]
  gem.authors           = ["redjazz96"]

  gem.files             = Dir["lib/**/*"] + Dir["spec/**/*"] + %w(Gemfile Gemfile.lock .rspec)
  gem.require_paths     = ["lib"]
  gem.test_files        = gem.files.grep(/\aspec\//)
  gem.add_development_dependency 'rspec'
end
