module Api
  module V1
    module Admin
      class MessagesController < BaseController
        def index
          # Using ContactMessage model from your existing routes
          messages = ContactMessage.all.order(created_at: :desc)
          render json: messages
        end
        
        def destroy
          message = ContactMessage.find(params[:id])
          message.destroy
          head :no_content
        end
      end
    end
  end
end