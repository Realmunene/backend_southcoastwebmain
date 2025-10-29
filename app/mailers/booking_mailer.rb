# app/mailers/booking_mailer.rb
class BookingMailer < ApplicationMailer
  default from: "onboarding@resend.dev"

  # =====================================
  # 🆕 New Booking Notification
  # =====================================
  def new_booking_notification
    @booking = params[:booking]
    @user = @booking.user
    @admin_email = "southcoastoutdoors25@gmail.com"

    mail(
      to: [@admin_email, @user.email],
      subject: "🛎️ New Booking Created by #{@user.email}"
    )
  end

  # =====================================
  # 🔄 Booking Update Notification
  # =====================================
  def update_booking_notification
    @booking = params[:booking]
    @user = @booking.user
    @admin_email = "southcoastoutdoors25@gmail.com"

    mail(
      to: [@admin_email, @user.email],
      subject: "🔄 Booking Updated by #{@user.email}"
    )
  end

  # =====================================
  # ❌ Booking Cancellation Notification
  # =====================================
  def cancel_booking_notification
    @booking = params[:booking]
    @user = @booking.user
    @admin_email = "southcoastoutdoors25@gmail.com"

    mail(
      to: [@admin_email, @user.email],
      subject: "❌ Booking Cancelled by #{@user.email}"
    )
  end
end
