env :PATH, ENV['PATH']
env :SECRET_KEY_BASE, ENV['SECRET_KEY_BASE']
set :output, "log/cron_log.log"

every 1.day, at: '0:00 am' do
  rake "delete:log_activity"
end
