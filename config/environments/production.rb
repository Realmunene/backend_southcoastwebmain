require "active_support/core_ext/integer/time"

# Ensure logs flush immediately
STDOUT.sync = true

Rails.application.configure do
  ##############################################
  # ✅ Force Rack::Cors middleware to run in production
  ##############################################
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      # Allow both local React app and deployed GitHub Pages site
      origins 'http://localhost:3001', 'https://realmunene.github.io'

      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        expose: ['Authorization'],
        credentials: false
    end
  end
  ##############################################

  # Code is not reloaded between requests
  config.enable_reloading = false

  # Eager load code on boot
  config.eager_load = true

  # Disable full error reports in production
  config.consider_all_requests_local = false

  # Serve static files
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Active Storage
  config.active_storage.service = :local

  # Force SSL
  config.assume_ssl = true
  config.force_ssl = true

  ##############################################
  # ✅ Logging to STDOUT for Render / Docker
  ##############################################
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = ::Logger::Formatter.new
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
  config.log_level = :debug
  config.log_tags  = [:request_id]

  # Silence healthcheck logs
  config.silence_healthcheck_path = "/up"

  config.active_support.report_deprecations = false

  # Use inline jobs (no solid_queue)
  config.active_job.queue_adapter = :inline

  # Fallbacks for I18n
  config.i18n.fallbacks = true

  # Don't dump schema after migrations
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  ##############################################
  # ✅ ActionMailer configured to use RESEND SMTP
  ##############################################
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
