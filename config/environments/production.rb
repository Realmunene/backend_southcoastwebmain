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

  # Eager load code on boot
  config.eager_load = true

  # Disable full error reports in production
  config.consider_all_requests_local = false

  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?

  config.active_storage.service = :local

  config.assume_ssl = true
  config.force_ssl = true

  config.log_tags = [:request_id]
  config.logger   = ActiveSupport::Logger.new(STDOUT)
  config.log_level = :debug

  config.silence_healthcheck_path = "/up"

  config.active_support.report_deprecations = false

  # Removed solid_cache_store
  # config.cache_store = :solid_cache_store

  # Removed solid_queue
  config.active_job.queue_adapter = :inline

  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  ##############################################
  # ✅ ActionMailer configured to use RESEND SMTP
  ##############################################

  # ✅ Required default URL options
  config.action_mailer.default_url_options = {
    host: ENV['APP_HOST'] || 'your-domain.com',
    protocol: 'https'
  }

  # ✅ Use SMTP delivery
  config.action_mailer.delivery_method = :smtp

  # ✅ Resend SMTP settings
  # NOTE: Use SMTP credentials from https://resend.com
  config.action_mailer.smtp_settings = {
    address:              "smtp.resend.com",
    port:                 587,
    user_name:            ENV['joseph.m.munene690'], # ORRK_****
    password:             ENV['re_JcE5pLSE_MTskgUR5Fag9s6TbUehPNdX9'], # API key token
    authentication:       :plain,
    enable_starttls_auto: true
  }

  # ✅ Recommended for debugging email delivery in production
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
end
