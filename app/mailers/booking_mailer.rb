
class BookingMailer < ApplicationMailer
  default from: "onboarding@resend.dev"
  BookingMailer.new_booking_notification(@booking).deliver_now
  def new_booking_notification(booking)
    @booking = booking
    mail(to: "joseph.m.munene690@gmail.com", subject: "✅ New Booking Received!")
  end

  def update_booking_notification(booking)
    @booking = booking
    mail(to: "joseph.m.munene690@gmail.com", subject: "✏️ Booking Updated!")
  end

  def cancel_booking_notification(booking)
    @booking = booking
    mail(to: "joseph.m.munene690@gmail.com", subject: "❌ Booking Cancelled!")
  end
end
