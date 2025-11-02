# app/mailers/test_mailer.rb
class TestMailer < ApplicationMailer
  def welcome_email
    mail(
      to: "joseph.m.munene690@gmail.com",
      subject: "Test Email from Resend",
      from: ENV.fetch("RESEND_USERNAME", "no-reply@southcoast.com")
    ) do |format|
      format.html { render html: "<h1>Hello from Resend!</h1>".html_safe }
    end
  end
end
