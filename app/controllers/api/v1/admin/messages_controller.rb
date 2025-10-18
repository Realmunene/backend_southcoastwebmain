module Api
  module V1
    module Admin
      class DashboardController < ApplicationController
        def stats
          total_bookings = Booking.count
          total_users = User.count
          render json: { bookings: total_bookings, users: total_users }
        end
      end
    end
  end
end
