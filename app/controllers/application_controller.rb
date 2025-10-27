# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :set_default_format

  ##################################
  # JWT ENCODING & DECODING
  ##################################
  def encode_token(payload, exp = 1.hour.from_now.to_i)
    payload[:exp] = exp
    payload[:role] ||= 'user' # ✅ Always set a default role
    JWT.encode(payload, secret_key, 'HS256')
  end

  def auth_header
    # Expected: Authorization: Bearer <token>
    request.headers['Authorization']
  end

  def decoded_token
    return nil unless auth_header
    token = auth_header.split(' ').last
    begin
      decoded = JWT.decode(token, secret_key, true, algorithm: 'HS256')
      decoded.first # return payload hash
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end

  ##################################
  # ROLE HELPERS
  ##################################
  def current_role
    decoded = decoded_token
    decoded ? decoded['role'] : nil
  end

  def role?(expected_role)
    current_role == expected_role
  end

  ##################################
  # ADMIN AUTH
  ##################################
  def current_admin
    return @current_admin if defined?(@current_admin)
    decoded = decoded_token
    if decoded && decoded['admin_id'] && %w[admin super_admin].include?(decoded['role'])
      @current_admin = Admin.find_by(id: decoded['admin_id'])
    end
  end

  def logged_in_admin?
    !!current_admin
  end

  def authorize_admin
    unless logged_in_admin?
      render json: { error: 'Forbidden: Admin must be logged in.' }, status: :forbidden
    end
  end

  ##################################
  # SUPER ADMIN AUTH
  ##################################
  def authorize_super_admin
    unless current_admin&.role == 'super_admin'
      render json: { error: 'Forbidden: Only Super Admin can perform this action.' }, status: :forbidden
    end
  end

  ##################################
  # USER AUTH
  ##################################
  def current_user
    return @current_user if defined?(@current_user)
    decoded = decoded_token
    if decoded && decoded['user_id'] && decoded['role'] == 'user'
      @current_user = User.find_by(id: decoded['user_id'])
    end
  end

  def logged_in_user?
    !!current_user
  end

  def authorize_user
    unless logged_in_user?
      render json: { error: 'Unauthorized: Please log in as a user.' }, status: :unauthorized
    end
  end

  ##################################
  # PARTNER AUTH (optional future)
  ##################################
  def current_partner
    return @current_partner if defined?(@current_partner)
    decoded = decoded_token
    if decoded && decoded['partner_id'] && decoded['role'] == 'partner'
      @current_partner = Partner.find_by(id: decoded['partner_id'])
    end
  end

  def logged_in_partner?
    !!current_partner
  end

  def authorize_partner
    unless logged_in_partner?
      render json: { error: 'Unauthorized: Please log in as partner.' }, status: :unauthorized
    end
  end

  ##################################
  # RESTRICT MULTIPLE ROLE SESSIONS
  ##################################
  def restrict_if_logged_in_different_role(required_role)
    decoded = decoded_token
    return unless decoded && decoded['role']

    current = decoded['role']
    if current != required_role
      render json: {
        error: "You are currently logged in as #{current.capitalize}. Please log out first to log in as #{required_role.capitalize}."
      }, status: :forbidden
    else
      render json: {
        error: "You are already logged in as #{current.capitalize}. Please log out before logging in again."
      }, status: :forbidden
    end
  end

  ##################################
  # PRIVATE HELPERS
  ##################################
  private

  def secret_key
    Rails.application.credentials.jwt_secret || Rails.application.secret_key_base
  end

  def set_default_format
    request.format = :json
  end
end
