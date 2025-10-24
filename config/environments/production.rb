require "active_support/core_ext/integer/time"

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

  # Settings specified here will take precedence over those in config/application.rb.
  config.active_model_secure_password_min_cost = false

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::Logger.new(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = :debug

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process memory cache store with a durable alternative.
  config.cache_store = :solid_cache_store

  # Replace the default in-process and non-durable queuing backend for Active Job.
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  ##############################################
  # ✅ Email Configuration for Production & Development
  ##############################################
  
  # Default URL options for Action Mailer
  config.action_mailer.default_url_options = { host: 'localhost:3000', protocol: 'http' }
  
  # SMTP settings for production
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV['SMTP_ADDRESS'] || 'smtp.gmail.com',
    port:                 ENV['SMTP_PORT'] || 587,
    domain:               ENV['SMTP_DOMAIN'] || 'localhost',
    user_name:            ENV['SMTP_USERNAME'],
    password:             ENV['SMTP_PASSWORD'],
    authentication:       ENV['SMTP_AUTHENTICATION'] || 'plain',
    enable_starttls_auto: ENV['SMTP_ENABLE_STARTTLS_AUTO'] != 'false'
  }

  # Don't care if the mailer can't send in production
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
end