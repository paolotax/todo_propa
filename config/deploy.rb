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

server "198.211.124.102", :web, :app, :db, primary: true

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

# Capistrano is using sudo, so set it to false
#set :use_sudo, false

# Your remote server is trying to checkout an SSH protected Git repository
#set :repository, '/var/git/repositories/xxx.git' # Remote server also holds the git repository
#set :local_repository, 'ssh://xxx/var/git/repositories/xxx.git' # Your development machine points to the remote machine 

# SSH settings, also see ~/.ssh/config
#set :user, "jebus"
#set :domain, 'xxx.com'
#set :port, 666

# Other settings worth checking
#ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
#default_run_options[:pty] = true # see http://www.mail-archive.com/capistrano@googlegroups.com/msg07323.html for details



after "deploy", "deploy:cleanup" # keep only the last 5 releases