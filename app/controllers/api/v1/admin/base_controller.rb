module Api
  module V1
    module Admin
      class BaseController < ApplicationController
        before_action :authenticate_admin!

        private

        def authenticate_admin!
          token = request.headers['Authorization']&.split(' ')&.last
          
          if token
            begin
              decoded_token = decode_token(token)
              admin_id = decoded_token['admin_id']
              @current_admin = ::Admin.find_by(id: admin_id)
            rescue JWT::DecodeError
              render json: { error: 'Invalid token' }, status: :unauthorized
              return
            end
          end
          
          unless @current_admin
            render json: { error: 'Not authorized' }, status: :unauthorized
          end
        end

        def current_admin
          @current_admin
        end

        def decode_token(token)
          JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' }).first
        end
      end
    end
  end
end