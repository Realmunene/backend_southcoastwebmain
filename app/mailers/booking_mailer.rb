# app/mailers/booking_mailer.rb
class BookingMailer < ApplicationMailer
  require 'resend'

  RESEND = Resend::Client.new(api_key: ENV['RESEND_API_KEY'])

  # New booking notification
  def new_booking_notification(booking)
    send_booking_email(
      booking,
      subject: "✅ New Booking Received!"
    )
  end

  # Booking update notification
  def update_booking_notification(booking)
    send_booking_email(
      booking,
      subject: "✏️ Booking Updated!"
    )
  end

  # Booking cancellation notification
  def cancel_booking_notification(booking)
    send_booking_email(
      booking,
      subject: "❌ Booking Cancelled!"
    )
  end

  private

  def send_booking_email(booking, subject:)
    html_content = booking_html(booking)

    RESEND.emails.send(
      from: "onboarding@resend.dev",
      to: "joseph.m.munene690@gmail.com",
      subject: subject,
      html: html_content
    )
  rescue => e
    Rails.logger.error "Failed to send #{subject} email: #{e.message}"
  end

  # Common HTML template for bookings
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
              <li>Nationality: #{booking.nationality}</li>
              <li>Room Type: #{booking.room_type}</li>
              <li>Check-in: #{booking.check_in}</li>
              <li>Check-out: #{booking.check_out}</li>
              <li>Guests: #{booking.guests}</li>
            </ul>
          </div>
        </body>
      </html>
    HTML
  end
end
