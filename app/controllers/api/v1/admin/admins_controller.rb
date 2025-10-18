# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Skip CSRF for API requests
  protect_from_forgery with: :null_session

  private

  # Encode JWT with expiry (default 24 hours)
  def encode_jwt(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # Decode JWT
  def decode_jwt(token)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue
    nil
  end

  # Get current admin from Authorization header
  def current_admin
    return @current_admin if @current_admin

    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header
    decoded = decode_jwt(token)
    @current_admin = ::Admin.find_by(id: decoded[:admin_id]) if decoded
  end

  # Protect routes
  def authorize_admin
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_admin
  end
end
