# app/mailers/booking_mailer.rb
class BookingMailer < ApplicationMailer
  default from: "no-reply@southcoast.com"

  # =====================================
  # New Booking Notification
  # =====================================
  def new_booking_notification(booking)
    @booking = booking
    @user = @booking.user
    @admin_email = "superadmin@southcoast.com" # Replace with your admin email

    mail(
      to: @admin_email,
      subject: "🛎️ New Booking Created by #{@user.email}"
    )
  end

  # =====================================
  # Booking Update Notification
  # =====================================
  def update_booking_notification(booking)
    @booking = booking
    @user = @booking.user
    @admin_email = "superadmin@southcoast.com"

    mail(
      to: @admin_email,
      subject: "🔄 Booking Updated by #{@user.email}"
    )
  end

  # =====================================
  # Booking Cancellation Notification
  # =====================================
  def cancel_booking_notification(booking)
    @booking = booking
    @user = @booking.user
    @admin_email = "superadmin@southcoast.com"

    mail(
      to: @admin_email,
      subject: "❌ Booking Cancelled by #{@user.email}"
    )
  end
end
