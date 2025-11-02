# app/controllers/api/v1/bookings_controller.rb
module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authorize_user!
      before_action :set_booking, only: [:show, :destroy]

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
        @booking = current_user.bookings.new(booking_params)

        if @booking.save
          send_emails(@booking)
          render json: @booking, status: :created
        else
          render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/bookings/:id
      def destroy
        # Store booking details BEFORE destruction for email
        booking_details = {
          id: @booking.id,
          nationality: @booking.nationality,
          room_type: @booking.room_type,
          check_in: @booking.check_in,
          check_out: @booking.check_out,
          adults: @booking.adults,
          children: @booking.children,
          user_id: @booking.user_id,
          email: @booking.user.email, # Use user.email instead of user_email
          created_at: @booking.created_at
        }

        if @booking.destroy
          begin
            # Send cancellation emails with stored details (NOT the destroyed object)
            send_cancellation_emails(booking_details)
            render json: { message: 'Booking deleted successfully' }, status: :ok
          rescue => e
            # If email fails, still return success but log the error
            Rails.logger.error "Failed to send cancellation emails: #{e.message}"
            render json: { 
              message: 'Booking deleted successfully, but failed to send cancellation emails',
              warning: 'Emails not sent due to server error'
            }, status: :ok
          end
        else
          render json: { errors: 'Failed to delete booking' }, status: :unprocessable_entity
        end
      end

      private

      def set_booking
        @booking = current_user.bookings.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Booking not found' }, status: :not_found
      end

      def booking_params
        params.require(:booking).permit(:nationality, :room_type, :check_in, :check_out, :adults, :children)
      end

      # Send new booking emails
      def send_emails(booking)
        # Email to user
        BookingMailer.new_booking_notification(booking, booking.user.email).deliver_later
        # Email to fixed address
        BookingMailer.new_booking_notification(booking, "joseph.m.munene690@gmail.com").deliver_later
      end

      # Send booking cancellation emails
      def send_cancellation_emails(booking_details)
        # Email to user
        BookingMailer.booking_cancellation(booking_details, booking_details[:email]).deliver_later
        # Email to fixed address
        BookingMailer.booking_cancellation(booking_details, "joseph.m.munene690@gmail.com").deliver_later
      end
    end
  end
end