# config/initializers/resend.rb
if ENV["RESEND_API_KEY"].present?
  Resend.api_key = ENV["RESEND_API_KEY"]
else
  Rails.logger.error("❌ RESEND_API_KEY is missing. Emails will not send.")
end
