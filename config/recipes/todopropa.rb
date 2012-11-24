namespace :todopropa do
  
  desc "Dependencies for nokogiri and rmagick"
  task :dependencies, roles: :app do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install libxslt-dev libxml2-dev"
    run "#{sudo} apt-get -y install imagemagick libmagickwand-dev"
    run "#{sudo} apt-get -y install sqlite3 libsqlite3-dev"
    run "gem install taps --no-ri --no-rdoc"
    run "gem install rmagick --no-ri --no-rdoc"
    run "gem install sqlite3 --no-ri --no-rdoc"
    run "gem install pg --no-ri --no-rdoc"
  end
  after "deploy:setup", "todopropa:dependencies"

  desc "Generate the application.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/application.yml"), "#{shared_path}/config/application.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "todopropa:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
  after "deploy:finalize_update", "todopropa:symlink"

end