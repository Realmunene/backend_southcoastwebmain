# config/environments/production.rb
require "active_support/core_ext/integer/time"

# Ensure logs are flushed immediately (no buffering)
STDOUT.sync = true
$stdout.sync = true
$stderr.sync = true

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
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.log_level = :info
  config.log_tags = [:request_id]
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false

  # Send all logs to STDOUT for Render visibility
  if ENV["RAILS_LOG_TO_STDOUT"].present? || ENV["RENDER"]
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # -----------------------------------------------
  # ✅ Action Mailer — Resend SMTP Configuration
  # -----------------------------------------------
  config.action_mailer.default_url_options = {
    host: ENV.fetch("APP_HOST", "backend-southcoastwebmain-1.onrender.com"),
    protocol: "https"
  }

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true

  # Resend SMTP configuration
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.resend.com",
    port:                 587,
    user_name:            ENV.fetch("RESEND_USERNAME", "onboarding@resend.dev"),
    password:             ENV.fetch("RESEND_API_KEY", ""),
    authentication:       :plain,
    enable_starttls_auto: true
  }

  # Log mailer activity clearly
  mail_logger = ActiveSupport::Logger.new(STDOUT)
  mail_logger.formatter = config.log_formatter
  config.action_mailer.logger = ActiveSupport::TaggedLogging.new(mail_logger)
  config.after_initialize do
    Rails.logger.info "✅ Resend SMTP configured successfully."
  end
end
