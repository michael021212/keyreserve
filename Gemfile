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

# Authentication
gem 'sorcery'
gem 'oauth2', '~> 1.3.0'
gem 'bcrypt', '~> 3.1.7'

# Configuration
gem 'dotenv-rails'
gem 'config'
gem 'enum_help'

# Search/Pagination
gem 'kaminari'
gem 'ransack'


group :development, :test do
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # gem 'capybara', '~> 2.13'
  # gem 'selenium-webdriver'

  # Email
  gem 'letter_opener'

  # CLI
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Test
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'simplecov', require: false

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
  # gem 'awesome_print'

  # Deploy
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
