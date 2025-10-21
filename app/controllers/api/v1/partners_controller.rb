# app/controllers/api/v1/partners_controller.rb
module Api
  module V1
    class PartnersController < ApplicationController
      # POST /api/v1/partners/register
      def register
        partner = Partner.new(partner_params)
        if partner.save
          token = encode_token({ partner_id: partner.id, role: 'partner' })
          render json: { message: 'Partner registered successfully', token: token, partner: partner }, status: :created
        else
          render json: { errors: partner.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def partner_params
        params.require(:partner).permit(
          :supplier_type,
          :supplier_name,
          :mobile,
          :email,
          :contact_person,
          :password,
          :description,
          :city,
          :address
        )
      end
    end
  end
end
