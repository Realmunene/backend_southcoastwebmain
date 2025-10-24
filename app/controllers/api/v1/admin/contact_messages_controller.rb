module Api
  module V1
    module Admin
      class ContactMessagesController < ApplicationController
        before_action :authenticate_admin!
        before_action :set_contact_message, only: [:show, :destroy, :mark_as_read]

        # GET /api/v1/admin/contact_messages
        def index
          contact_messages = ContactMessage.order(created_at: :desc)
          render json: { contact_messages: contact_messages }, status: :ok
        end

        # GET /api/v1/admin/contact_messages/:id
        def show
          render json: @contact_message
        end

        # PATCH /api/v1/admin/contact_messages/:id/mark_as_read
        def mark_as_read
          if @contact_message.update(status: 'read')
            render json: { message: "Message marked as read." }, status: :ok
          else
            render json: { error: "Failed to update message." }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/contact_messages/:id
        def destroy
          @contact_message.destroy
          render json: { message: "Message deleted successfully." }, status: :ok
        end

        private

        def set_contact_message
          @contact_message = ContactMessage.find(params[:id])
        end

        # ✅ Admin Auth using JWT
        def authenticate_admin!
          token = request.headers['Authorization']&.split(' ')&.last

          unless token
            render json: { error: "Missing authentication token" }, status: :unauthorized
            return
          end

          begin
            decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)
            admin_id = decoded[0]["admin_id"]
            @current_admin = Admin.find_by(id: admin_id)
          rescue JWT::DecodeError
            render json: { error: "Invalid token" }, status: :unauthorized
            return
          end

          unless @current_admin
            render json: { error: "Unauthorized admin" }, status: :unauthorized
          end
        end

        # ✅ Safer global fallback
        rescue_from StandardError do |e|
          Rails.logger.error("ContactMessagesController Error: #{e.message}")
          render json: { error: "Internal Server Error: #{e.message}" }, status: 500
        end
      end
    end
  end
end
