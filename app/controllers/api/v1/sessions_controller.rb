# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < ApplicationController
      # ======================
      # Admin Login
      # POST /api/v1/admin/login
      # ======================
      def login_admin
        email = params.dig(:session, :email) || params[:email]
        password = params.dig(:session, :password) || params[:password]

        admin = ::Admin.find_by(email: email)

        if admin&.authenticate(password)
          token = encode_token({ admin_id: admin.id })
          render json: { message: "Admin logged in successfully", admin: admin, token: token }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      # GET /api/v1/admin/profile
      before_action :authorize_admin, only: [:admin_profile]
      def admin_profile
        render json: { admin: current_admin }, status: :ok
      end

      # ======================
      # User Login
      # POST /api/v1/user/login
      # ======================
      def login_user
        email = params.dig(:session, :email) || params[:email]
        password = params.dig(:session, :password) || params[:password]

        user = User.find_by(email: email)

        if user&.authenticate(password)
          token = encode_token({ user_id: user.id })
          render json: { message: "User logged in successfully", user: user, token: token }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      # GET /api/v1/user/profile
      before_action :authorize_user, only: [:user_profile]
      def user_profile
        render json: { user: current_user }, status: :ok
      end

      # ======================
      # Logout (for both User & Admin)
      # DELETE /api/v1/logout
      # ======================
      def destroy
        # JWT logout: client removes token; server can optionally blacklist if implemented
        # For session-based auth:
        reset_session
        render json: { message: "Logged out successfully" }, status: :ok
      end
    end
  end
end
