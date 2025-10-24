Rails.application.routes.draw do
  # 👇 Root path for the backend API (so Render doesn’t error on /)
  root to: proc { [200, {}, ['Backend API running successfully']] }

  namespace :api do
    namespace :v1 do
      # ===========================
      # Authentication
      # ===========================
      post "/admin/login", to: "sessions#login_admin"
      post "/user/login", to: "sessions#login_user"
      delete "/logout", to: "sessions#destroy"

      # ===========================
      # Partners — Self Service
      # ===========================
      post 'partners/register', to: 'partners#register'

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
      # Admin Namespace
      # ===========================
      namespace :admin do
        get 'dashboard', to: 'dashboard#index'
        get 'stats', to: 'dashboard#stats'
        resources :bookings, only: [:index, :create, :update, :destroy]
        resources :users, only: [:index, :destroy]
        resources :admins, only: [:index, :create, :update, :destroy]
        resources :contact_messages, only: [:index, :show, :destroy]
        resources :partners, only: [:index, :show, :create, :destroy]
      end

      # ===========================
      # Support Messages
      # ===========================
      resources :support_messages, only: [:create, :index]

      # ===========================
      # Contact Messages
      # ===========================
      resources :contact_messages, only: [:create, :index]

      # ===========================
      # Health Check
      # ===========================
      get "up" => "rails/health#show", as: :rails_health_check
    end
  end
end
