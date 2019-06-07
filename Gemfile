source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'jbuilder', '~> 2.5'
gem 'devise'
gem 'paper_trail'
gem 'sentry-raven'
gem "pundit"
gem 'kaminari'
gem 'axlsx_rails'
gem 'textacular', '~> 5.0'
gem "fog"
gem "fog-aws"
gem 'carrierwave'
gem 'postgresql_cursor', '~> 0.6.1'
gem 'dalli'
gem 'memcachier'
gem 'actionpack-action_caching'
gem 'rails-observers'
gem 'sidekiq'
gem 'redis-namespace'
gem 'redis'
gem 'mailgun-ruby', '~>1.1.6'

group :production, :staging do
  gem 'scout_apm'
  gem 'meta_request'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'factory_bot'
  gem 'pry-byebug'
  gem 'rubocop'
  gem 'pronto'
  gem 'pronto-rubocop'
  gem 'traceroute'
end

group :development, :staging do
  gem 'rack-mini-profiler', require: false
  gem 'memory_profiler'
  gem 'flamegraph'
  gem 'stackprof'
  gem 'fast_stack'
  gem 'bullet'
  gem 'letter_opener'
end

gem 'pretender'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.5.0'
