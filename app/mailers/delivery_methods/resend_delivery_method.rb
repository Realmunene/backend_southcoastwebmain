# app/mailers/delivery_methods/resend_delivery_method.rb
require "net/http"
require "json"

class ResendDeliveryMethod
  def initialize(settings = {})
    @api_key = settings[:api_key] || ENV.fetch("RESEND_API_KEY")
  end

  def deliver!(mail)
    uri = URI("https://api.resend.com/emails")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    body = {
      from: mail.from.first,
      to: mail.to,
      subject: mail.subject,
      html: mail.body.raw_source
    }

    request = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{@api_key}"
    })

    request.body = body.to_json

    response = http.request(request)
    raise "Resend email failed: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    response
  end
end
