class BookingMailer < ApplicationMailer
  default from: "no-reply@southcoast.com"
  ADMIN_EMAIL = "southcoastoutdoors25@gmail.com"

  # =====================================
  # 🆕 New Booking Notification
  # =====================================
  def new_booking_notification
    @booking = params[:booking]
    return if @booking.blank?

    @user = @booking.user || @booking.try(:created_by)
    @booker_email = @user&.email || "Unknown User"

    mail(
      to: ADMIN_EMAIL,
      subject: "🛎️ New Booking Created by #{@booker_email}"
    )
  end

  # =====================================
  # 🔄 Booking Update Notification
  # =====================================
  def update_booking_notification
    @booking = params[:booking]
    return if @booking.blank?

    @user = @booking.user || @booking.try(:updated_by)
    @booker_email = @user&.email || "Unknown User"

    mail(
      to: ADMIN_EMAIL,
      subject: "🔄 Booking Updated by #{@booker_email}"
    )
  end

  # =====================================
  # ❌ Booking Cancellation Notification
  # =====================================
  def cancel_booking_notification
    @booking = params[:booking]
    return if @booking.blank?

    @user = @booking.user || @booking.try(:cancelled_by)
    @booker_email = @user&.email || "Unknown User"

    mail(
      to: ADMIN_EMAIL,
      subject: "❌ Booking Cancelled by #{@booker_email}"
    )
  end
end