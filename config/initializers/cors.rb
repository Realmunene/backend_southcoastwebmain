# Be sure to restart your server when you modify this file.

# Handle Cross-Origin Resource Sharing (CORS) to allow frontend apps to access the API.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # ✅ Allow local React app (for development) and deployed GitHub Pages (for production)
    origins 'http://localhost:3000', 'https://realmunene.github.io'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization'],
      credentials: false
  end
end
