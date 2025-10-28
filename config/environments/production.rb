require "active_support/core_ext/integer/time"

Rails.application.configure do
  STDOUT.sync = true  # Ensure unbuffered logs

  # Force Rack::Cors middleware for React frontend
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:3001', 'https://realmunene.github.io'
      resource '*',
               headers: :any,
               methods: [:get, :post, :put, :patch, :delete, :options, :head],
               expose: ['Authorization'],
               credentials: false
    end
  end

  # Performance & caching
  config.active_model_secure_password_min_cost = false
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  # Serve static files
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  config.active_storage.service = :local
  config.force_ssl = true
  config.assume_ssl = true

  # Logging to STDOUT for Render
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = ::Logger::Formatter.new
  logger.auto_flushing = true
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
  config.log_level = :debug
  config.log_tags  = [:request_id]

  # Active Job
  config.active_job.queue_adapter = :inline

  # I18n fallbacks
  config.i18n.fallbacks = true

  # Schema dump
  config.active_record.dump_schema_after_migration = false

  # ActionMailer with Resend SMTP
  config.action_mailer.default_url_options = {
    host: ENV['APP_HOST'] || 'your-domain.com',
    protocol: 'https'
  }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.resend.com",
    port: 587,
    user_name: ENV['RESEND_USERNAME'],
    password: ENV['RESEND_API_KEY'],
    authentication: :plain,
    enable_starttls_auto: true
  }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
end
