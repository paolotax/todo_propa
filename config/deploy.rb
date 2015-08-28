require "bundler/capistrano"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"
load "config/recipes/todopropa"

server "188.166.55.65", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "todo_propa"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:paolotax/#{application}.git"
set :branch, "goose"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases