Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # ===========================
      # Authentication
      # ===========================
      post "/admin/login", to: "sessions#login_admin"
      post "/user/login", to: "sessions#login_user"
      delete "/logout", to: "sessions#destroy"  # <-- Logout route

      # ===========================
      # Users
      # ===========================
      resources :users, only: [:create]

      # ===========================
      # Room Types
      # ===========================
      resources :room_types, only: [:index]

      # ===========================
      # Nationalities
      # ===========================
      resources :nationalities, only: [:index]

      # ===========================
      # Bookings (User)
      # ===========================
      resources :bookings, only: [:create, :index, :show, :update, :destroy]

      # ===========================
      # Admin Dashboard & Admin Resources
      # ===========================
      namespace :admin do
        get 'stats', to: 'dashboard#stats'

        resources :bookings, only: [:index, :create, :update, :destroy]
        resources :users, only: [:index, :destroy]
        resources :admins, only: [:index, :create, :destroy]
        resources :messages, only: [:index, :destroy]
      end

      # ===========================
      # Support Messages
      # ===========================
      resources :support_messages, only: [:create]

      # ===========================
      # Contact Messages
      # ===========================
      resources :contact_messages, only: [:create]

      # ===========================
      # Health Check
      # ===========================
      get "up" => "rails/health#show", as: :rails_health_check
    end
  end
end
