# app/mailers/booking_mailer.rb
require "resend"

class BookingMailer < ApplicationMailer
  default from: "onboarding@resend.dev"

  # ✅ Initialize Resend client safely
  api_key = ENV["RESEND_API_KEY"]
  if api_key.nil? || !api_key.is_a?(String) || api_key.strip.empty?
    Rails.logger.error("❌ Missing or invalid RESEND_API_KEY environment variable!")
    raise "Invalid RESEND_API_KEY: Must be a non-empty string"
  end

  RESEND_CLIENT = Resend::Client.new(api_key: api_key)

  # ✅ New booking notification
  def new_booking_notification(booking)
    @booking = booking
    RESEND_CLIENT.emails.send(
      from: "onboarding@resend.dev",
      to: "joseph.m.munene690@gmail.com",
      subject: "✅ New Booking Received!",
      html: booking_html(@booking)
    )
  rescue => e
    Rails.logger.error("Failed to send new booking email: #{e.message}")
  end

  # ✅ Update booking notification
  def update_booking_notification(booking)
    @booking = booking
    RESEND_CLIENT.emails.send(
      from: "onboarding@resend.dev",
      to: "joseph.m.munene690@gmail.com",
      subject: "✏️ Booking Updated!",
      html: booking_html(@booking)
    )
  rescue => e
    Rails.logger.error("Failed to send update booking email: #{e.message}")
  end

  # ✅ Cancel booking notification
  def cancel_booking_notification(booking)
    @booking = booking
    RESEND_CLIENT.emails.send(
      from: "onboarding@resend.dev",
      to: "joseph.m.munene690@gmail.com",
      subject: "❌ Booking Cancelled!",
      html: booking_html(@booking)
    )
  rescue => e
    Rails.logger.error("Failed to send cancel booking email: #{e.message}")
  end

  private

  # ✅ Shared HTML template for all emails
  def booking_html(booking)
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <style>
            body { font-family: Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 20px; }
            .container { background-color: #fff; padding: 20px; border-radius: 5px; }
            h1 { color: #333; }
            ul { padding-left: 20px; }
            li { margin-bottom: 5px; }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>Booking Notification</h1>
            <p>Here are the booking details:</p>
            <ul>
              <li><strong>Nationality:</strong> #{booking.nationality}</li>
              <li><strong>Room Type:</strong> #{booking.room_type}</li>
              <li><strong>Check-in:</strong> #{booking.check_in}</li>
              <li><strong>Check-out:</strong> #{booking.check_out}</li>
              <li><strong>Guests:</strong> #{booking.guests}</li>
            </ul>
          </div>
        </body>
      </html>
    HTML
  end
end
