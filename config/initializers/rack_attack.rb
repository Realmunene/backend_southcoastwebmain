class Rack::Attack
  # ✅ Allow all local traffic
  safelist('allow-localhost') do |req|
    req.ip == '127.0.0.1' || req.ip == '::1'
  end

  # ✅ Throttle login attempts by IP (5 requests per minute)
  throttle('limit logins', limit: 5, period: 60.seconds) do |req|
    if req.path == '/api/login' && req.post?
      req.ip
    end
  end

  # ✅ Updated: use throttled_responder instead of throttled_response
  self.throttled_responder = lambda do |request|
    [
      429, # status
      { 'Content-Type' => 'application/json' },
      [ { error: 'Too many login attempts. Please try again later.' }.to_json ]
    ]
  end
end
