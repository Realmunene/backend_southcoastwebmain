# app/mailers/booking_mailer.rb
class BookingMailer < ApplicationMailer
  default from: "onboarding@resend.dev"

  # New booking notification
  def new_booking_notification(booking)
    @booking = booking
    mail(
      to: "joseph.m.munene690@gmail.com",
      subject: "✅ New Booking Received!"
    ) do |format|
      format.html { render html: booking_html(@booking).html_safe }
    end
  end

  # Booking update notification
  def update_booking_notification(booking)
    @booking = booking
    mail(
      to: "joseph.m.munene690@gmail.com",
      subject: "✏️ Booking Updated!"
    ) do |format|
      format.html { render html: booking_html(@booking).html_safe }
    end
  end

  # Booking cancellation notification
  def cancel_booking_notification(booking)
    @booking = booking
    mail(
      to: "joseph.m.munene690@gmail.com",
      subject: "❌ Booking Cancelled!"
    ) do |format|
      format.html { render html: booking_html(@booking).html_safe }
    end
  end

  private

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
