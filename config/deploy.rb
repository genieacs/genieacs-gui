# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "genieacs-gui"
set :repo_url, "git@github.com:BananaCoding/genieacs-gui.git"
set :default_stage, "staging"
set :user, "deploy"
set :branch, ENV['BRANCH'] || 'master'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/srv/www/apps/genieacs-gui"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files,
       'config/database.yml',
       'config/secrets.yml',
       'config/unicorn.rb',
       'config/graphs.json.erb',
       'config/index_parameters.yml',
       'config/summary_parameters.yml',
       'config/parameters_edit.yml',
       'config/parameter_renderers.yml'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :rails_env, 'production'
set :rbenv_type, :user
set :rbenv_ruby, '2.5.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, "config/unicorn.rb"
set :unicorn_rack_env, 'production'
set :unicorn_roles, :web

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
