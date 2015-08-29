namespace :redis do

  desc "Install redis"
  task :install, roles: :app do
    
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install redis-server"
    #run "#{sudo} update-rc.d redis-server /etc/redis.conf"
    
    # ["cd /tmp",
    #  "wget http://download.redis.io/redis-stable.tar.gz",
    #  "tar xvzf redis-stable.tar.gz", 
    #  "cd redis-stable", 
    #  "make", 
    #  "#{sudo} cp /tmp/redis-stable/src/redis-benchmark /usr/local/bin/",
    #  "#{sudo} cp /tmp/redis-stable/src/redis-cli /usr/local/bin/",
    #  "#{sudo} cp /tmp/redis-stable/src/redis-server /usr/local/bin/",
    #  "#{sudo} cp /tmp/redis-stable/redis.conf /etc/",
    #  "#{sudo} sed -i 's/daemonize no/daemonize yes/' /etc/redis.conf",
    #  "#{sudo} sed -i 's/^pidfile \/var\/run\/redis.pid/pidfile \/tmp\/redis.pid/' /etc/redis.conf"].each {|cmd| run cmd}

    start
  end
  after "deploy:install", "redis:install"

  desc "Start the Redis server"
  task :start do
    run "redis-server /etc/redis.conf"
  end

  desc "Stop the Redis server"
  task :stop do
    run 'echo "SHUTDOWN" | nc localhost 6379'
  end

end