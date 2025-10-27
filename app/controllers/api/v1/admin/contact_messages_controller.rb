module Api
  module V1
    module Admin
      class ContactMessagesController < ApplicationController
        before_action :authenticate_admin!
        before_action :set_contact_message, only: [:show, :destroy]

        def index
          contact_messages = ContactMessage.order(created_at: :desc)
          render json: contact_messages, status: :ok
        end

        def show
          render json: @contact_message, status: :ok
        end

        def destroy
          @contact_message.destroy
          head :no_content
        end

        private

        def set_contact_message
          @contact_message = ContactMessage.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Message not found" }, status: :not_found
        end

        def authenticate_admin!
          header = request.headers['Authorization']

          unless header.present?
            return render json: { error: "Missing Authorization header" }, status: :unauthorized
          end

          token = header.split(" ").last

          begin
            decoded = JWT.decode(
              token,
              Rails.application.credentials.secret_key_base, # ✅ Rails 8 safe
              true,
              { algorithm: "HS256" }
            )

            admin_id = decoded[0]["admin_id"]
            @current_admin = ::Admin.find_by(id: admin_id) # ✅ global reference

          rescue JWT::DecodeError => e
            return render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
          end

          unless @current_admin
            return render json: { error: "Unauthorized admin" }, status: :unauthorized
          end
        end
      end
    end
  end
end
