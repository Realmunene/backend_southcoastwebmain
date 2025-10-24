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
          unless current_user&.admin?
            render json: { error: "Unauthorized" }, status: :unauthorized
          end
        end
      end
    end
  end
end
