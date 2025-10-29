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
            # ✅ Send admin notification immediately (sync)
            begin
              BookingMailer.new_booking_notification(booking).deliver_now
              Rails.logger.info "📧 New booking email sent successfully for admin-created booking ##{booking.id}"
            rescue => e
              Rails.logger.error "📧 Failed to send booking email: #{e.message}"
            end
            
            render json: booking, status: :created
          else
            render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/admin/bookings/:id
        def update
          if @booking.update(booking_params)
            # ✅ Send update notification immediately (sync)
            begin
              BookingMailer.update_booking_notification(@booking).deliver_now
              Rails.logger.info "📧 Booking update email sent successfully for booking ##{@booking.id}"
            rescue => e
              Rails.logger.error "📧 Failed to send update email: #{e.message}"
            end
            
            render json: @booking, status: :ok
          else
            render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/bookings/:id
        def destroy
          # ✅ Send cancellation notification immediately (sync)
          begin
            BookingMailer.cancel_booking_notification(@booking).deliver_now
            Rails.logger.info "📧 Booking cancellation email sent successfully for booking ##{@booking.id}"
          rescue => e
            Rails.logger.error "📧 Failed to send cancellation email: #{e.message}"
          end
          
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