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
        if booking
          render json: booking, status: :ok
        else
          render json: { error: "Booking not found" }, status: :not_found
        end
      end

      # POST /api/v1/bookings
      def create
        booking = current_user.bookings.new(booking_params)

        if booking.save
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
        render json: { message: "Booking deleted" }, status: :ok
      end

      private

      # Strong parameters (user_id removed)
      def booking_params
        params.require(:booking).permit(:nationality, :room_type, :check_in, :check_out, :guests)
      end

      # Authorization using JWT
      def authorize_user!
  header = request.headers["Authorization"]
  token = header&.split(" ")&.last

  if token.present?
    begin
      # ✅ Use credentials for secret_key_base
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
      @current_user = User.find_by(id: decoded[0]["user_id"])
      render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
    rescue JWT::DecodeError => e
      render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
    end
  else
    render json: { error: "Missing token" }, status: :unauthorized
  end
end


      # Helper method to access current_user in controller
      def current_user
        @current_user
      end
    end
  end
end
