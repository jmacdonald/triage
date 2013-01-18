# Set this to the directory containing Triage.
triage_directory = '/var/www/triage'

# Set this to the number of cores on the server.
worker_processes 2

# Set the working directory for unicorn.
working_directory triage_directory

# Load the app once in the master process.
preload_app true

# Kill worker process running longer than 30 seconds.
timeout 30

# Listen on a unix socket. Backlog is set to ensure quicker failover when busy.
listen "#{triage_directory}/tmp/unicorn.sock", :backlog => 64

# Set the PID path.
pid "#{triage_directory}/tmp/unicorn.pid"

# Set logging paths.
stderr_path "#{triage_directory}/log/unicorn.stderr.log"
stdout_path "#{triage_directory}/log/unicorn.stdout.log"

# Release the database connection from the master process. Required when preload_app is true.
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

# Establish connection from worker processes.
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
