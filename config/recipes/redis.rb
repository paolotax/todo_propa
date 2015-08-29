namespace :redis do

  desc "Install redis"
  task :install, roles: :app do
    
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install redis-server"
    
  end
  after "deploy:install", "redis:install"

end