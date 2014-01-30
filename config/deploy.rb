require "bundler/capistrano"

raise "Supply all ENV params: gmail, etc" if ENV["GMAIL_USERNAME"]
  .nil? || ENV["GMAIL_PASSWORD"].nil?

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

server "109.74.204.118", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "learnster"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:full-of-foo/#{application}.git"
set :branch, fetch(:branch, "master")
set :scm_verbose, true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :gmail_user, ENV["GMAIL_USERNAME"]
set :gmail_pass, ENV["GMAIL_PASSWORD"]

after "deploy", "deploy:cleanup" # keep only the last 5 releases
