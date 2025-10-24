module Api
  module V1
    module Admin
      class ContactMessagesController < ApplicationController
        before_action :set_contact_message, only: [:show, :destroy]
        before_action :authenticate_admin!

        def index
          @contact_messages = ContactMessage.all.order(created_at: :desc)
          render json: @contact_messages
        end

        def show
          render json: @contact_message
        end

        def destroy
          @contact_message.destroy
          head :no_content
        end

        private

        def set_contact_message
          @contact_message = ContactMessage.find(params[:id])
        end

        def authenticate_admin!
          token = request.headers['Authorization']&.split(' ')&.last
          
          if token
            begin
              decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
              admin_id = decoded_token[0]['admin_id']
              @current_admin = Admin.find_by(id: admin_id)
            rescue JWT::DecodeError
              render json: { error: "Invalid token" }, status: :unauthorized
              return
            end
          end

          unless @current_admin
            render json: { error: "Unauthorized" }, status: :unauthorized
          end
        end
      end
    end
  end
end