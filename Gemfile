source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development do
  gem 'sqlite3'
  gem 'slice', :path => '~/projects/slice'
end

group :op do
  gem 'authlogic'
  gem 'json'
  gem 'cancan'
  gem 'kaminari'
  gem 'plugin_manager', :github => "redjazz96/plugin-manager"
end

group :post_formats do
  gem 'rdiscount'
  #gem 'rbcode', :github => "redjazz96/rbcode" # I'll need to rewrite this before I can use it
  gem 'rbbcode'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'

gem 'thin'
# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
#gem 'ruby-debug'