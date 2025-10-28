# app/controllers/api/v1/admin/bookings_controller.rb
module Api
  module V1
    module Admin
      class BookingsController < ApplicationController
        before_action :authorize_admin!
        before_action :set_booking, only: [:show, :update, :destroy]

        # GET /api/v1/admin/bookings
        def index
          bookings = Booking.order(created_at: :desc)
          render json: bookings, status: :ok
        end

        # GET /api/v1/admin/bookings/:id
        def show
          render json: @booking, status: :ok
        end

        # PATCH/PUT /api/v1/admin/bookings/:id
        def update
          if @booking.update(booking_params)
            BookingMailer.update_booking_notification(@booking)
            render json: @booking, status: :ok
          else
            render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/bookings/:id
        def destroy
          @booking.destroy
          BookingMailer.cancel_booking_notification(@booking)
          render json: { message: "Booking cancelled successfully" }, status: :ok
        end

        private

        def set_booking
          @booking = Booking.find(params[:id])
        end

        def booking_params
          params.require(:booking).permit(:nationality, :room_type, :check_in, :check_out, :guests)
        end
      end
    end
  end
end
