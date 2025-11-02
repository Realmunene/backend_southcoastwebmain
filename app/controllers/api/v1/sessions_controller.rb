# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < ApplicationController
      ##################################
      # 👑 ADMIN LOGIN
      # POST /api/v1/admin/login
      ##################################
      def login_admin
        email = params.dig(:session, :email) || params[:email]
        password = params.dig(:session, :password) || params[:password]

        admin = ::Admin.find_by(email: email)

        if admin&.authenticate(password)
          token = encode_token({ admin_id: admin.id, role: admin.role })
          render json: {
            message: "Admin logged in successfully",
            admin: admin,
            token: token
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      before_action :authorize_admin!, only: [:admin_profile]

      def admin_profile
        render json: { admin: current_admin }, status: :ok
      end

      ##################################
      # 👤 USER LOGIN
      # POST /api/v1/user/login
      ##################################
      def login_user
        email = params.dig(:session, :email) || params[:email]
        password = params.dig(:session, :password) || params[:password]

        user = User.find_by(email: email)

        if user&.authenticate(password)
          token = encode_token({ user_id: user.id, role: "user" })
          render json: {
            message: "User logged in successfully",
            user: user,
            token: token
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      before_action :authorize_user!, only: [:user_profile]

      def user_profile
        render json: { user: current_user }, status: :ok
      end

      ##################################
      # 🚪 LOGOUT (for both Admin & User)
      # DELETE /api/v1/logout
      ##################################
      def destroy
        if auth_header
          decoded = decoded_token
          revoke_token(decoded) if decoded
        end

        reset_session
        render json: { message: "Logged out successfully. Token revoked." }, status: :ok
      end

      ##################################
      # 🔒 SUPER ADMIN CHECK
      ##################################
      private

      def authorize_super_admin
        unless current_admin && current_admin.role == "super_admin"
          render json: { error: "Forbidden: Only Super Admin can perform this action" }, status: :forbidden
        end
      end
    end
  end
end
