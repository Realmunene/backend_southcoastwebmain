require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

# ✅ Optional: configure Resend mail delivery safely
begin
  require "resend"
  require "action_mailer"

  # Only register if not already present
  unless ActionMailer::Base.delivery_methods.key?(:resend)
    ActionMailer::Base.add_delivery_method(:resend, Mail::SMTP) # fallback to SMTP-like structure
  end
rescue LoadError => e
  warn "⚠️ Resend not fully initialized: #{e.message}"
end

module BackendSouthcoastwebmain
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true
    # autoload app/lib
    config.autoload_paths << Rails.root.join("app/mailers/delivery_methods")

    # ✅ Add minimal middleware for cookies/sessions if needed
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # ✅ Allow only local frontend (React dev server)
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:3001'
        resource '*',
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 expose: ['Authorization'],
                 credentials: false
      end
    end

    # ✅ Inline jobs for simplicity
    config.active_job.queue_adapter = :inline
  end
end
