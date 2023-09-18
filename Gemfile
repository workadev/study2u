source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.6"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails", "1.1.5"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "1.2.1"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development, :staging do
  # Help Kill N+1
  gem 'bullet'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'spring'
  gem 'spring-watcher-listen'

  # Deployment
  gem 'capistrano',                   '~> 3.11',  require: false
  gem 'capistrano-rbenv',             '~> 2.1',   require: false
  gem 'capistrano-bundler',                       require: false
  gem 'capistrano-rails',             '~> 1.4',   require: false
  gem 'capistrano3-puma',             '5.2.0',    require: false
  gem 'capistrano-sidekiq',                       require: false
  gem 'capistrano-logtail',           '~> 0.1',   require: false
  gem 'capistrano-rails-console',     '~> 2.3',   require: false
  gem 'capistrano-local-precompile',  '~> 1.2.0', require: false
  gem 'capistrano-faster-assets',     '~> 1.0',   require: false
  gem 'capistrano-rails-collection',  '~> 0.1.0', require: false
  gem "capistrano-anycable",                      require: false

  gem 'listen'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'pry-rails'
  gem 'table_print'

  # Annotate documentation
  gem 'annotate'

  # Email fake
  gem 'letter_opener'
  gem 'letter_opener_web'

  # Rails console nicely printout
  gem 'awesome_print'

  # Generate Rails ERD
  gem 'rails-erd'

  # Performance
  #############
  # Rails Best Practice Guideline
  gem 'rails_best_practices'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Search
gem 'ransack', '3.2.1'

# https://github.com/ddnexus/pagy
gem 'pagy', '6.0.1'
gem 'api-pagination'

# Authentication & Authorization
gem 'devise'
gem 'pundit'

# Uploading
gem 'shrine'
gem 'image_processing'
gem 'aws-sdk'
gem 'aws-sdk-s3'

# Scheduler
gem 'whenever'
gem 'sidekiq', '6.5.8'
gem 'sidekiq-scheduler', '5.0.1'
gem 'sidekiq-cron', '1.9.1'

# API
gem 'jwt'
gem 'oj'
gem 'rack-cors'
# Alba is a JSON serializer for Ruby, JRuby, and TruffleRuby.
gem 'alba'

# Exception & Monitoring
gem 'exception_notification'

# Store global variables per environment
gem 'dotenv-rails'
gem 'seedbank'
# gem 'twilio-ruby', '5.74.1'
# Activity Tracking
# gem 'device_detector', '1.1.0'
gem 'authtrail', '0.4.3'
gem 'geocoder', '1.8.1'
# gem 'maxminddb', '0.1.22'

# gem "searchkick"
# gem "elasticsearch"
#gem "opensearch-ruby"
#gem "faraday_middleware-aws-sigv4"

# To run daemonized anycabled
# gem 'daemons', '~> 1.4', '>= 1.4.1'
# gem "anycable-rails", "~> 1.1"

# handle otp on staging and development env
# gem "active_model_otp", '2.3.1'

# Use to access REST API pubnub
gem "httparty"
# gem "audited"

# data dummy
gem 'faker', '~> 3.1', '>= 3.1.1'

# view component
gem 'view_component', '~> 3.5'

# A simple ActiveRecord mixin to add conventions for flagging records as discarded.
# gem 'discard', '~> 1.2'

gem 'tinymce-rails', '5.2.1'

gem 'cocoon', '1.2.15'
gem 'rack-cors'
