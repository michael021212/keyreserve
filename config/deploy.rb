# config valid only for current version of Capistrano
lock "3.9.1"

set :application, "keyreserve"
set :repo_url, "git@github.com:startup-technology/keyreserve.git"
set :deploy_to, '/var/www/keyreserve'

# Default branch is :master
set :branch, ENV['BRANCH'] || 'master'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for :pty is false
set :pty, true
# Default value for keep_releases is 5
set :keep_releases, 5
# Default value for linked_dirs is []
set :linked_dirs, %w(log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle)
# Default value for :linked_files is []
set :linked_files, %w(.env config/database.yml)
set :rbenv_type, :user
set :rbenv_path, '/usr/local/rbenv'
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "WEBPACKER_COMPILE=false RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_roles, :all

namespace :deploy do
  desc "Restart Application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end
end
