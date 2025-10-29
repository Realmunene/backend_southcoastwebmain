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

        # POST /api/v1/admin/bookings
        def create
          booking = Booking.new(booking_params.merge(user_id: params[:user_id]))

          if booking.save
            # ✅ Notify admin (self) when admin manually creates a booking
            BookingMailer.with(booking: booking).new_booking_notification.deliver_later
            render json: booking, status: :created
          else
            render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/admin/bookings/:id
        def update
          if @booking.update(booking_params)
            # ✅ Notify admin of booking updates
            BookingMailer.with(booking: @booking).update_booking_notification.deliver_later
            render json: @booking, status: :ok
          else
            render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/bookings/:id
        def destroy
          # ✅ Notify admin before deletion
          BookingMailer.with(booking: @booking).cancel_booking_notification.deliver_later
          @booking.destroy
          head :no_content
        end

        private

        def set_booking
          @booking = Booking.find(params[:id])
        end

        def booking_params
          params.require(:booking).permit(:user_id, :nationality, :room_type, :check_in, :check_out, :guests)
        end
      end
    end
  end
end
