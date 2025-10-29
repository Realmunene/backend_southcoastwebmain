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
        booking = current_user.bookings.find(params[:id])
        render json: booking, status: :ok
      end

      # POST /api/v1/bookings
      def create
        booking = current_user.bookings.new(booking_params)

        if booking.save
          # ✅ Send admin notification only
          BookingMailer.with(booking: booking).new_booking_notification.deliver_later
          render json: booking, status: :created
        else
          render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def booking_params
        params.require(:booking).permit(:nationality, :room_type, :check_in, :check_out, :guests)
      end
    end
  end
end
