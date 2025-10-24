# app/mailers/booking_mailer.rb
class BookingMailer < ApplicationMailer
  def new_booking_notification(booking)
    @booking = booking
    mail(to: 'joseph.m.munene690@gmail.com', subject: "New Booking - #{@booking.id}")
  end
end
