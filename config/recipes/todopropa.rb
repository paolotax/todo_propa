namespace :todopropa do
  
  desc "Dependencies for nokogiri and rmagick"
  task :dependencies, roles: :app do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install libxslt-dev libxml2-dev"
    run "#{sudo} apt-get -y install imagemagick libmagickwand-dev"
    run "#{sudo} apt-get -y install sqlite3 libsqlite3-dev"
    run "gem install taps --no-ri --no-rdoc"
    run "gem install rmagick --no-ri --no-rdoc"
  end
  after "deploy:setup", "todopropa:dependencies"

end