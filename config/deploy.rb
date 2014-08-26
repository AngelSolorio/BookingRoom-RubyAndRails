require "bundler/capistrano"
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'BookingRoom'
set :repo_url, 'git://github.com/AngelSolorio/BookingRoom-RubyAndRails.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/html/bookingroom'

# Default value for :scm is :git
 set :scm, :git
 set :branch, "master"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :user, "arturogro"

# Generate an additional task to fire up the thin clusters
namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run  <<-CMD
      cd /var/www/html/bookingroom/current; bundle exec thin start -C config/thin.yml
    CMD
  end

  desc "Stop the Thin processes"
  task :stop do
    run <<-CMD
      cd /var/www/html/bookingroom/current; bundle exec thin stop -C config/thin.yml
    CMD
  end

  desc "Restart the Thin processes"
  task :restart do
    run <<-CMD
      cd /var/www/html/bookingroom/current; bundle exec thin restart -C config/thin.yml
    CMD
  end

end

# Define all the tasks that need to be running manually after Capistrano is finished.
after "deploy:finalize_update", "deploy:update_cv_assets"
after "deploy", "deploy:migrate"