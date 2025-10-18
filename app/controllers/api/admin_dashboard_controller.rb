class Api::AdminDashboardController < ApplicationController
  before_action :authorize_request

  def index
    render json: { message: "Welcome to the Admin Dashboard!", admin: @current_admin.email }
  end

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      @current_admin = Admin.find(decoded["admin_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
