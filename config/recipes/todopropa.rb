namespace :todopropa do
  
  desc "Dependencies for nokogiri and rmagick"
  task :dependencies, roles: :app do
    run "#{sudo} apt-get install libxslt-dev libxml2-dev"
    run "#{sudo} apt-get install imagemagick libmagickwand-dev"
    run "#{sudo} apt-get install sqlite3 libsqlite3-dev"
    run "gem install taps --nori-nordoc"
    run "gem install rmagick --nori-nordoc"
  end
  after "deploy:setup", "todopropa:dependencies"

end