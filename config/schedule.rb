set :output, "#{path}/log/cron.log"

every 5.minutes do
  runner "Cliente.ricalcola_properties"
end
