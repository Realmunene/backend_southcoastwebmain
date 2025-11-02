# app/mailers/booking_mailer.rb
class BookingMailer < ApplicationMailer
  default from: 'bookings@yourhotel.com'

  # New booking notification
  def new_booking_notification(booking, recipient_email)
    @booking = booking
    @total_guests = booking.adults + booking.children
    mail(to: recipient_email, subject: "🛎️ New Booking Received")
  end

  # Booking cancellation notification
  def booking_cancellation(booking_details, recipient_email)
    @booking_details = booking_details
    @total_guests = booking_details[:adults] + booking_details[:children]
    mail(to: recipient_email, subject: "❌ Booking Cancelled")
  end
end