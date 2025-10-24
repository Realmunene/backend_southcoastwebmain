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
          booking = Booking.new(booking_params)

          if booking.save
            # ✅ Trigger notification email safely
            begin
              BookingMailer.new_booking_notification(booking).deliver_later
              Rails.logger.info "Admin booking notification queued for booking #{booking.id}"
            rescue => e
              Rails.logger.error "Failed to queue booking email: #{e.message}"
            end

            render json: {
              message: "✅ Booking created",
              booking: booking
            }, status: :created
          else
            render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PATCH/PUT /api/v1/admin/bookings/:id
        def update
          if @booking.update(booking_params)
            render json: {
              message: "✅ Booking updated",
              booking: @booking
            }, status: :ok
          else
            render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/bookings/:id
        def destroy
          @booking.destroy
          render json: { message: "🗑️ Booking deleted" }, status: :ok
        end

        private

        def set_booking
          @booking = Booking.find_by(id: params[:id])
          return render json: { error: "Booking not found" }, status: :not_found unless @booking
        end

        def booking_params
          params.require(:booking).permit(
            :nationality,
            :room_type,
            :check_in,
            :check_out,
            :guests,
            :user_id,  # Admin can attach user
            :status,
            :notes
          )
        end

        # ✅ JWT admin guard
        def authorize_admin!
          header = request.headers["Authorization"]
          token = header&.split(" ")&.last

          unless token.present?
            return render json: { error: "Missing token" }, status: :unauthorized
          end

          begin
            decoded = JWT.decode(
              token,
              Rails.application.credentials.secret_key_base,
              true,
              { algorithm: "HS256" }
            )

            # ✅ Ensure model lookup uses global scope
            @current_admin = ::Admin.find_by(id: decoded[0]["admin_id"])

            unless @current_admin && @current_admin.role == 0
              return render json: { error: "Forbidden: Admin access only" }, status: :forbidden
            end

          rescue JWT::DecodeError => e
            return render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
          end
        end

        def current_admin
          @current_admin
        end
      end
    end
  end
end
