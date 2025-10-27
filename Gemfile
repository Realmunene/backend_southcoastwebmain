source "https://rubygems.org"
ruby '3.4.7'

# Core Rails
gem "rails", "~> 8.1.0"

# PostgreSQL database
gem "pg", "~> 1.1"

# Puma web server
gem "puma", ">= 5.0"

# Email sending (SendGrid + Resend)
gem "sendgrid-ruby"
gem "resend"

# Authentication
gem "bcrypt", "~> 3.1.7"
gem "jwt"

# Countries helper
gem "countries"

# Allow CORS & rate limiting
gem 'rack-cors'
gem 'rack-attack'

# Fix fiddle warning
# gem "fiddle"

# Needed on Windows
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Faster boots
gem "bootsnap", require: false

# Container deployments
gem "kamal", require: false

# Puma acceleration
gem "thruster", require: false

# ✅ ✅ Solid gems used ONLY in production (never on Windows dev)
group :production do
  gem "solid_cache"
end
group :development, :test do
  gem 'dotenv-rails'
end

# Development / Test tools
group :development, :test do
  # Ruby debugger
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Security static analysis
  gem "brakeman", require: false

  # Ruby/rails style linter
  gem "rubocop-rails-omakase", require: false
end
