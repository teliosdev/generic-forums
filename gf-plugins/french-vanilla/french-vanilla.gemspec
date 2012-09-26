Gem::Specification.new do |gem|
  gem.name    = 'french-vanilla'
  gem.version = '0.1.1'
  gem.date    = Date.today.to_s

  gem.summary     = "French Vanilla, an extention to generic forums"
  gem.description = "A basic extension to generic forums that adds things like points, and the text editor."

  gem.author   = 'Jeremy Rodi'
  gem.email    = 'redjazz96@gmail.com'

  gem.files = Dir['{vendor,lib,app,db}/**/*']

  gem.add_dependency 'delayed_job_active_record'
  gem.add_dependency 'activerecord-reputation-system'
end
