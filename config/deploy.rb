# config valid only for current version of Capistrano
lock '3.6.1'

set :application, ENV['DEPLOY_APP_NAME']
set :repo_url, ENV['DEPLOY_REPO_URL']

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# set :branch, ENV['DEPLOY_BRANCH']
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, ENV['DEPLOY_DIR']

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, ENV['DEPLOY_RVM_RUBY_VERSION']      # Defaults to: 'default'
set :sidekiq_monit_default_hooks, false