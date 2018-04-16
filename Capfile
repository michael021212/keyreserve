# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require 'capistrano/rails'
# require 'capistrano/yarn'
require 'capistrano/rails/migrations'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/puma'
install_plugin Capistrano::Puma
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
require "whenever/capistrano"
# require 'capistrano/delayed_job'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
