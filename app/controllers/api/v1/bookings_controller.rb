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
          # ✅ Send admin notification immediately (sync)
          begin
            BookingMailer.new_booking_notification(booking).deliver_now
            Rails.logger.info "📧 New booking email sent successfully for booking ##{booking.id}"
          rescue => e
            Rails.logger.error "📧 Failed to send booking email: #{e.message}"
            # Continue anyway - don't let email failure break booking creation
          end
          
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