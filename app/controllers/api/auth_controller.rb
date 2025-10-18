require 'jwt'

class Api::AuthController < ApplicationController
  SECRET_KEY = Rails.application.secret_key_base

  def login
  admin = Admin.find_by(email: params[:email])
  Rails.logger.info "Admin login attempt: #{admin&.email || 'unknown'} from IP #{request.remote_ip}"

  if admin && admin.authenticate(params[:password])
    token = encode_token({ admin_id: admin.id })
    cookies.signed[:admin_token] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict
    }
    render json: { admin: { email: admin.email } }, status: :ok
  else
    render json: { error: "Invalid email or password" }, status: :unauthorized
  end
end


  private

  def encode_token(payload)
    payload[:exp] = 2.hours.from_now.to_i  # ⏳ Token expires after 2 hours
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def decoded_token(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
  rescue JWT::ExpiredSignature
    nil
  rescue JWT::DecodeError
    nil
  end
end
