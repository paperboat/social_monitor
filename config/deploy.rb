require "bundler/capistrano"
require "rvm/capistrano"
require "capistrano-resque"

set :rvm_ruby_string, '1.9.3'

server "62.75.158.63", :web, :app, :db, :resque_worker, :resque_scheduler, primary: true

set :application, "social_monitor"
set :user, "deployer"
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :workers, { "crawl" => 2 }
set :workers, { "statistics" => 2 }

set :scm, "git"
set :repository, "git@github.com:paperboat/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy', 'deploy:cleanup'
after 'deploy', 'deploy:migrate'
after "deploy:restart", "resque:restart"

namespace :deploy do
  %w[start stop restart reload].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "sudo /etc/init.d/unicorn_#{application} #{command}"
    end
  end

  # Use this if you know what you are doing.
  #
  # desc "Zero-Downtime restart of Unicorn"
  # task :restart, :except => { :no_release => true } do
  #   run "sudo /etc/init.d/unicorn_#{application} reload"
  # end
end