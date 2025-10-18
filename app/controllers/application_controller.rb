# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :set_default_format

  ##########################
  # Common JWT Methods
  ##########################

  # Encode JWT token with optional expiration (default 1 hour)
  def encode_token(payload, exp = 1.hour.from_now.to_i)
    payload[:exp] = exp
    JWT.encode(payload, secret_key, 'HS256')
  end

  # Get Authorization header
  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  # Decode JWT token
  def decoded_token
    return nil unless auth_header

    token = auth_header.split(' ').last
    begin
      decoded = JWT.decode(token, secret_key, true, algorithm: 'HS256')
      decoded.first # payload hash
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end

  ##########################
  # User Authentication
  ##########################

  def current_user
    return @current_user if defined?(@current_user)
    decoded = decoded_token
    if decoded && decoded['user_id']
      @current_user = User.find_by(id: decoded['user_id'])
    end
  end

  def logged_in_user?
    !!current_user
  end

  def authorize_user
    render json: { error: 'Please log in as user' }, status: :unauthorized unless logged_in_user?
  end

  ##########################
  # Admin Authentication
  ##########################

  def current_admin
    return @current_admin if defined?(@current_admin)
    decoded = decoded_token
    if decoded && decoded['admin_id']
      @current_admin = Admin.find_by(id: decoded['admin_id'])
    end
  end

  def logged_in_admin?
    !!current_admin
  end

  def authorize_admin
    render json: { error: 'Please log in as admin' }, status: :unauthorized unless logged_in_admin?
  end

  ##########################
  # Private Helpers
  ##########################
  private

  def secret_key
    # Use Rails credentials in production
    Rails.application.credentials.jwt_secret || Rails.application.secret_key_base
  end

  def set_default_format
    request.format = :json
  end
end
