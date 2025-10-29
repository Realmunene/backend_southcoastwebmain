# app/controllers/api/v1/admin/bookings_controller.rb
module Api
  module V1
    module Admin
      class BookingsController < ApplicationController
        before_action :authenticate_user!          # Ensure user is logged in
        before_action :authorize_admin!            # Ensure user has admin privileges
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
          booking = Booking.new(booking_params)

          if booking.save
            Rails.logger.info "📧 Email notification disabled temporarily - Admin created Booking ##{booking.id}"
            render json: booking, status: :created
          else
            render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/admin/bookings/:id
        def update
          if @booking.update(booking_params)
            Rails.logger.info "📧 Email notification disabled temporarily - Booking ##{@booking.id} updated"
            render json: @booking, status: :ok
          else
            render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/bookings/:id
        def destroy
          Rails.logger.info "📧 Email notification disabled temporarily - Booking ##{@booking.id} cancelled"
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

        # ✅ Ensure only admins can access admin endpoints
        def authorize_admin!
          unless current_user&.admin?
            render json: { error: "Forbidden — Admin access only" }, status: :forbidden
          end
        end
      end
    end
  end
end
