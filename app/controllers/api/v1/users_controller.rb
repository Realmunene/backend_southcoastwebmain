module Api
  module V1
    class UsersController < ApplicationController
      def login
        restrict_if_logged_in_different_role('user')

        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = encode_token({ user_id: user.id, role: 'user' })
          render json: { token: token, role: 'user' }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: { message: "User created successfully", user: user }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :phone, :password)
      end
    end
  end
end
