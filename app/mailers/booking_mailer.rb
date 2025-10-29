class BookingMailer < ApplicationMailer
  default from: "no-reply@southcoast.com"
  ADMIN_EMAIL = "southcoastoutdoors25@gmail.com"

  # =====================================
  # 🆕 New Booking Notification
  # =====================================
  def new_booking_notification(booking)
    @booking = booking
    return if @booking.blank?

    @user = @booking.user
    @booker_email = @user&.email || "Unknown User"

    # Simple mail call without complex parameters
    mail(
      to: ADMIN_EMAIL,
      subject: "🛎️ New Booking Created by #{@booker_email}"
    )
  rescue => e
    Rails.logger.error "Email failed to send: #{e.message}"
    # Don't re-raise the error to prevent booking creation from failing
  end

  # =====================================
  # 🔄 Booking Update Notification
  # =====================================
  def update_booking_notification(booking)
    @booking = booking
    return if @booking.blank?

    @user = @booking.user
    @booker_email = @user&.email || "Unknown User"

    mail(
      to: ADMIN_EMAIL,
      subject: "🔄 Booking Updated by #{@booker_email}"
    )
  rescue => e
    Rails.logger.error "Email failed to send: #{e.message}"
  end

  # =====================================
  # ❌ Booking Cancellation Notification
  # =====================================
  def cancel_booking_notification(booking)
    @booking = booking
    return if @booking.blank?

    @user = @booking.user
    @booker_email = @user&.email || "Unknown User"

    mail(
      to: ADMIN_EMAIL,
      subject: "❌ Booking Cancelled by #{@booker_email}"
    )
  rescue => e
    Rails.logger.error "Email failed to send: #{e.message}"
  end
end