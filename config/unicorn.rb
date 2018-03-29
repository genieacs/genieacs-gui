# If you have a very small app you may be able to
# increase this, but in general 3 workers seems to
# work best
worker_processes 3

# Load your app into the master before forking
# workers for super-fast worker spawn times
preload_app true

# Immediately restart any workers that
# haven't responded within 30 seconds
timeout 30

working_directory '/srv/www/apps/genieacs-gui/current'
shared_directory = '/srv/www/apps/genieacs-gui/shared'
listen "#{shared_directory}/tmp/sockets/unicorn.sock", :backlog => 64
pid "#{shared_directory}/tmp/pids/unicorn.pid"
stderr_path "#{shared_directory}/log/unicorn.stderr.log"
stdout_path "#{shared_directory}/log/unicorn.stdout.log"

before_fork do |server, worker|
    if defined?(ActiveRecord::Base)
        ActiveRecord::Base.connection.disconnect!
        Rails.logger.info('Disconnected from ActiveRecord')
    end
    sleep 1
end

after_fork do |server, worker|
    if defined?(ActiveRecord::Base)
        ActiveRecord::Base.establish_connection
        Rails.logger.info('Connected to ActiveRecord')
    end
end
