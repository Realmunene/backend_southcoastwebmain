Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # ===========================
      # Authentication
      # ===========================
      post "/admin/login", to: "sessions#login_admin"
      post "/user/login", to: "sessions#login_user"
      delete "/logout", to: "sessions#destroy"
      # Partners — Self Service
      # ===========================
      post 'partners/register', to: 'partners#register'   # ✅ Partner registers themselves


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
        # 📊 Dashboard
        get 'dashboard', to: 'dashboard#index'
        get 'stats', to: 'dashboard#stats'

        # 🏨 Manage Bookings
        resources :bookings, only: [:index, :create, :update, :destroy]

        # 👤 Manage Users
        resources :users, only: [:index, :destroy]

        # 👑 Manage Admins (super_admin only)
        resources :admins, only: [:index, :create, :update, :destroy]

        # 💬 Manage Messages
        resources :messages, only: [:index, :destroy]

        # 🤝 Manage Partners
        resources :partners, only: [:index, :show, :create, :destroy]
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
