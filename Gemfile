source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'

# SERVER
gem 'redis', '~> 3.0'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.7'

# API
gem 'grape'
gem 'grape-jbuilder'
gem 'hashie'
gem 'json_expressions'
gem 'jwt'
gem 'http'

# UI/UX
gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'page_title_helper'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'bootstrap_form'
gem 'adminlte2-rails'
gem 'jquery-slimscroll-rails'
gem 'rails_autolink'
gem 'draper'
gem 'gon'
gem 'cocoon'
gem 'chosen-rails'

# Authentication
gem 'sorcery'
gem 'oauth2', '~> 1.3.0'
gem 'bcrypt', '~> 3.1.7'
gem 'twilio-ruby'

# Configuration
gem 'dotenv-rails'
gem 'config'
gem 'enum_help'

# Notification
gem 'exception_notification'
gem 'slack-notifier'

# Search/Pagination
gem 'kaminari'
gem 'ransack'

# validation
gem 'email_validator'

# Soft delete
gem 'paranoia'
gem 'paranoia_uniqueness_validator', '3.0.0'

# Breadcrumbs
gem 'gretel'

# Seeds
gem 'seed-fu'

# HTTP client lib
gem 'faraday'
gem 'patron'

# Upload
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-aws'
gem 'carrierwave-data-uri'
gem 'rmagick'

# Credit Card
gem 'stripe'

# PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'


gem 'nested_form'
gem 'geocoder'
gem 'phonelib'

gem 'whenever', require: false
gem 'letter_opener_web'

group :development, :test do
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'selenium-webdriver'

  # Email

  # Geocoding

  # manage multiple nested models

  # CLI
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Test
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'factory_bot_rails'
  gem 'capybara'
  gem 'spring-commands-rspec'
  gem 'simplecov', require: false
  gem 'launchy'
  gem 'chromedriver-helper' unless ENV['CI']
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'vcr'
  gem 'webmock'
  gem 'database_cleaner'

  # Code analyze
  gem 'rubocop'

  # Debugger
  gem 'byebug'
  gem 'better_errors'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-stack_explorer'

  # Print debug
  gem 'awesome_print'

  # Deploy
  gem 'capistrano', '3.9.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rails-console'
  gem 'capistrano-rbenv'
  gem 'capistrano-rbenv-vars'
  # gem 'capistrano-resque', require: false
  gem 'capistrano3-puma'
  # gem 'capistrano-yarn'
  # gem 'capistrano3-delayed-job'
end

group :development do
  gem 'rails-erd'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

