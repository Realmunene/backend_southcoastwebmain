# config/environments/production.rb
require "active_support/core_ext/integer/time"

# Ensure logs flush immediately (important for Render)
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

  # ✅ Log everything to STDOUT (Render visibility)
  if ENV["RAILS_LOG_TO_STDOUT"].present? || ENV["RENDER"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # -----------------------------------------------
  # ✅ Action Mailer Configuration (Render + Gmail)
  # -----------------------------------------------
  config.action_mailer.default_url_options = {
    host: ENV.fetch("APP_HOST", "backend-southcoastwebmain-1.onrender.com"),
    protocol: "https"
  }

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  # ✅ Use Gmail SMTP for all outgoing mail
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "gmail.com",
    user_name:            ENV["GMAIL_USERNAME"],
    password:             ENV["GMAIL_PASSWORD"],
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # ✅ Mailer logging (visible in Render logs)
  mail_logger = ActiveSupport::Logger.new(STDOUT)
  mail_logger.formatter = config.log_formatter
  config.action_mailer.logger = ActiveSupport::TaggedLogging.new(mail_logger)

  # ✅ Verify mail configuration after boot
  config.after_initialize do
    if ENV["GMAIL_USERNAME"].present? && ENV["GMAIL_PASSWORD"].present?
      Rails.logger.info "✅ Gmail SMTP mailer configured successfully."
    else
      Rails.logger.warn "⚠️ Missing Gmail credentials — emails will not be sent."
      config.action_mailer.perform_deliveries = false
    end
  end
end
