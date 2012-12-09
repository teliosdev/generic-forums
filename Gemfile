source 'http://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

group :development do
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :op do
  gem 'authlogic'
  gem 'json'
  gem 'cancan'
  gem 'kaminari'
  gem 'plugin_manager', :github => "redjazz96/plugin-manager"
end

group :post_stuff do
  gem 'rdiscount'
  gem 'paper_trail', '~> 2'
  gem 'paperclip'
  gem 'differ'
  gem 'impressionist'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  #gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

# For the public API
group :api do
  gem 'rabl'
  gem 'yajl-ruby', :require => 'yajl'
end

gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.0.0'


gem 'thin'
# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
#gem 'ruby-debug'
