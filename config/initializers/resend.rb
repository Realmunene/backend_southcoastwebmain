require "resend"

Resend.api_key = ENV.fetch("RESEND_API_KEY")

# Define Resend as an ActionMailer delivery method manually
class ResendDeliveryMethod
  def initialize(_settings = {})
  end

  def deliver!(mail)
    Resend::Emails.send(
      from: mail.from.first,
      to: mail.to,
      subject: mail.subject,
      html: mail.html_part ? mail.html_part.body.decoded : mail.body.decoded
    )
  end
end

ActionMailer::Base.add_delivery_method :resend, ResendDeliveryMethod
