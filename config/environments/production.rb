# config/environments/production.rb
require "active_support/core_ext/integer/time"

STDOUT.sync = true

Rails.application.configure do
  # -----------------------------------------------
  # ✅ Core Rails Production Configuration
  # -----------------------------------------------
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # -----------------------------------------------
  # ✅ Asset and Logging Settings
  # -----------------------------------------------
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.log_level = :info
  config.log_tags = [:request_id]
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false

  # -----------------------------------------------
  # ✅ Action Mailer — Resend SMTP Configuration
  # -----------------------------------------------
  config.action_mailer.default_url_options = {
    host: ENV['APP_HOST'] || 'your-domain.com',
    protocol: 'https'
  }

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true

  # Use Resend’s SMTP endpoint for email delivery
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.resend.com",
    port: 587,
    user_name: ENV.fetch("RESEND_USERNAME", "onboarding@resend.dev"),
    password: ENV.fetch("RESEND_API_KEY", ""),
    authentication: :plain,
    enable_starttls_auto: true
  }

  # Log successful deliveries
  config.action_mailer.logger = ActiveSupport::Logger.new(STDOUT)
  config.action_mailer.logger.info "✅ Resend SMTP configured successfully."
end
