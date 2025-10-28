# app/controllers/api/v1/bookings_controller.rb
module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authorize_user!
      before_action :set_booking, only: [:show, :update, :destroy]

      # GET /api/v1/bookings
      def index
        bookings = current_user.bookings.order(created_at: :desc)
        render json: bookings, status: :ok
      end

      # GET /api/v1/bookings/:id
      def show
        render json: @booking, status: :ok
      end

      # POST /api/v1/bookings
      def create
        booking = current_user.bookings.new(booking_params)

        if booking.save
          # Send booking notification via Resend
          BookingMailer.new_booking_notification(booking)

          render json: booking, status: :created
        else
          render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/bookings/:id
      def update
        if @booking.update(booking_params)
          # Send booking update notification via Resend
          BookingMailer.update_booking_notification(@booking)

          render json: @booking, status: :ok
        else
          render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/bookings/:id
      def destroy
        @booking.destroy
        # Send booking cancellation notification via Resend
        BookingMailer.cancel_booking_notification(@booking)

        render json: { message: "Booking cancelled successfully" }, status: :ok
      end

      private

      def set_booking
        @booking = current_user.bookings.find(params[:id])
      end

      def booking_params
        params.require(:booking).permit(:nationality, :room_type, :check_in, :check_out, :guests)
      end
    end
  end
end
