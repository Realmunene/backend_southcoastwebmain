# Puma can serve each request in a thread from an internal thread pool.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Port to listen on (Render uses $PORT)
port ENV.fetch("PORT") { 3000 }

# Environment
environment ENV.fetch("RAILS_ENV") { "development" }

# PID file
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Workers for clustered mode (only in production)
if ENV["RAILS_ENV"] == "production"
  workers ENV.fetch("WEB_CONCURRENCY") { 4 }
  preload_app!   # Load app before workers
end

# Allow puma to be restarted by `rails restart`
plugin :tmp_restart
