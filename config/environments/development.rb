# config/environments/development.rb
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  # Caching
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.public_file_server.headers = { "cache-control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
  end

  config.cache_store = :memory_store
  config.active_storage.service = :local

  ##############################################
  # ✅ Email Configuration (Gmail for Dev)
  ##############################################
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # Use Gmail SMTP
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "gmail.com",
    user_name:            ENV.fetch("GMAIL_USERNAME"), # e.g., your email
    password:             ENV.fetch("GMAIL_APP_PASSWORD"), # app password recommended
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # Default email sender
  config.action_mailer.default_options = {
    from: ENV.fetch("GMAIL_USERNAME", "no-reply@southcoast.com")
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  ##############################################
  # ✅ General Rails Development Settings
  ##############################################
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_job.verbose_enqueue_logs = true
  config.active_job.queue_adapter = :inline

  config.action_view.annotate_rendered_view_with_filenames = true
  config.action_controller.raise_on_missing_callback_actions = true

  config.action_dispatch.cookies_same_site_protection = :none
  config.action_dispatch.cookies_serializer = :json
  config.session_store :cookie_store, key: '_southcoast_session', same_site: :none, secure: true
end
