# app/controllers/api/v1/bookings_controller.rb
module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authorize_user!

      # GET /api/v1/bookings
      def index
        bookings = current_user.bookings.order(created_at: :desc)
        render json: bookings, status: :ok
      end

      # GET /api/v1/bookings/:id
      def show
        booking = current_user.bookings.find_by(id: params[:id])
        return render json: { error: "Booking not found" }, status: :not_found unless booking

        render json: booking, status: :ok
      end

      # POST /api/v1/bookings
      def create
        booking = current_user.bookings.new(booking_params)

        if booking.save
          send_email(:new, booking)
          render json: { message: "Booking successful", booking: booking }, status: :created
        else
          render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/bookings/:id
      def update
        booking = current_user.bookings.find_by(id: params[:id])
        return render json: { error: "Booking not found" }, status: :not_found unless booking

        if booking.update(booking_params)
          send_email(:updated, booking)
          render json: { message: "Booking updated", booking: booking }, status: :ok
        else
          render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/bookings/:id
      def destroy
        booking = current_user.bookings.find_by(id: params[:id])
        return render json: { error: "Booking not found" }, status: :not_found unless booking

        booking.destroy
        send_email(:cancelled, booking)
        render json: { message: "Booking cancelled" }, status: :ok
      end

      private

      def booking_params
        params.require(:booking).permit(
          :nationality,
          :room_type,
          :check_in,
          :check_out,
          :guests
        )
      end

      def authorize_user!
        header = request.headers["Authorization"]
        token  = header&.split(" ")&.last
        return render json: { error: "Missing token" }, status: :unauthorized unless token

        begin
          decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
          @current_user = User.find_by(id: decoded[0]["user_id"])
          return render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
        rescue JWT::DecodeError => e
          return render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
        end
      end

      def current_user
        @current_user
      end

      # Send email using Resend API
      def send_email(type, booking)
        case type
        when :new
          BookingMailer.new_booking_notification(booking)
        when :updated
          BookingMailer.update_booking_notification(booking)
        when :cancelled
          BookingMailer.cancel_booking_notification(booking)
        end
      rescue => e
        Rails.logger.error "Failed to send #{type} email: #{e.message}"
      end
    end
  end
end
